{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  appName = "Paneru";
  bundleId = "com.github.karinushka.paneru";
  certName = "Paneru Local Code Signing";
  stableAppPath = "/Applications/${appName}.app";
  userHome = config.users.users.${config.system.primaryUser}.home;
  stableConfigPath = "${userHome}/.paneru.toml";
  paneruVersion = paneruPackage.version or "unstable";
  bundleVersion = lib.head (lib.splitString "+" paneruVersion);

  infoPlist = pkgs.writeText "Info.plist" (
    lib.concatStringsSep "\n" [
      ''<?xml version="1.0" encoding="UTF-8"?>''
      ''<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">''
      ''<plist version="1.0">''
      "<dict>"
      "<key>CFBundleDevelopmentRegion</key>"
      "<string>en</string>"
      "<key>CFBundleExecutable</key>"
      "<string>paneru</string>"
      "<key>CFBundleIdentifier</key>"
      "<string>${bundleId}</string>"
      "<key>CFBundleInfoDictionaryVersion</key>"
      "<string>6.0</string>"
      "<key>CFBundleName</key>"
      "<string>${appName}</string>"
      "<key>CFBundlePackageType</key>"
      "<string>APPL</string>"
      "<key>CFBundleShortVersionString</key>"
      "<string>${bundleVersion}</string>"
      "<key>CFBundleVersion</key>"
      "<string>${bundleVersion}</string>"
      "<key>LSUIElement</key>"
      "<true/>"
      "<key>NSHumanReadableCopyright</key>"
      "<string>Copyright (c) 2025 Karinushka@github. All rights reserved.</string>"
      "</dict>"
      "</plist>"
      ""
    ]
  );

  paneruPackage = inputs.paneru.packages.${pkgs.stdenv.hostPlatform.system}.default;
  tomlFormat = pkgs.formats.toml { };
  paneruConfig = tomlFormat.generate "paneru.toml" {
    options = {
      focus_follows_mouse = false;
      mouse_follows_focus = false;
      preset_column_widths = [
        0.33
        0.5
        0.67
        1
      ];
      window_resize_cycle = false;
      animation_speed = 20;
      sliver_width = 2;
    };
    bindings = {
      window_focus_west = "cmd + ctrl - h";
      window_focus_east = "cmd + ctrl - l";
      window_focus_north = "cmd + ctrl - k";
      window_focus_south = "cmd + ctrl - j";
      window_swap_west = "alt + ctrl - h";
      window_swap_east = "alt + ctrl - l";
      window_swap_first = "alt + shift - h";
      window_swap_last = "alt + shift - l";
      window_center = "alt - c";
      window_resize = "alt - r";
      window_shrink = "alt + shift - r";
      window_fullwidth = "cmd + alt - f";
      window_manage = "cmd + alt - t";
      window_stack = "alt + ctrl - ]";
      window_unstack = "alt + ctrl - [";
    };
    windows.all = {
      title = ".*";
      horizontal_padding = 2;
      vertical_padding = 2;
    };
    swipe = {
      sensitivity = 1;
      deceleration = 3;
      gesture.fingers_count = 3;
    };
    decorations.inactive.dim = {
      opacity = -0.015;
      opacity_night = -0.025;
    };
  };

  paneruApp = pkgs.stdenvNoCC.mkDerivation {
    pname = "paneru-app";
    version = "unstable";

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      app="$out/Applications/${appName}.app"
      mkdir -p "$app/Contents/MacOS"

      install -m 0755 ${lib.getExe paneruPackage} "$app/Contents/MacOS/paneru"
      install -m 0644 ${infoPlist} "$app/Contents/Info.plist"

      runHook postInstall
    '';
  };
in
{
  environment.systemPackages = [ paneruPackage ];

  launchd.user.agents.paneru = {
    serviceConfig = {
      Label = bundleId;
      KeepAlive = {
        Crashed = true;
        SuccessfulExit = false;
      };
      Nice = -20;
      ProcessType = "Interactive";
      Program = "${stableAppPath}/Contents/MacOS/paneru";
      EnvironmentVariables = {
        NO_COLOR = "1";
        PANERU_CONFIG = stableConfigPath;
      };
      RunAtLoad = true;
      StandardOutPath = "/tmp/paneru.log";
      StandardErrorPath = "/tmp/paneru.err.log";
    };
  };

  system.activationScripts.extraActivation.text = lib.mkAfter ''
    set -euo pipefail

    app_source="${paneruApp}/Applications/${appName}.app"
    app_target="${stableAppPath}"
    cert_name="${certName}"
    keychain="/Library/Keychains/System.keychain"
    p12_password="paneru-local-code-signing"

    if [ -e "$app_target" ] && [ ! -d "$app_target" ]; then
      echo "Refusing to replace non-directory at $app_target" >&2
      exit 1
    fi

    tmp_dir="$(/usr/bin/mktemp -d /tmp/paneru-signing.XXXXXX)"
    cleanup() {
      /bin/rm -rf "$tmp_dir"
    }
    trap cleanup EXIT

    if ! /usr/bin/security find-identity -p codesigning "$keychain" | /usr/bin/grep -F "$cert_name" >/dev/null; then
      echo "Creating local Paneru code signing identity: $cert_name"
      /usr/bin/security delete-certificate -c "$cert_name" "$keychain" >/dev/null 2>&1 || true
      ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:2048 -days 3650 -nodes \
        -quiet \
        -keyout "$tmp_dir/paneru.key" \
        -out "$tmp_dir/paneru.crt" \
        -subj "/CN=$cert_name" \
        -addext "keyUsage=critical,digitalSignature" \
        -addext "extendedKeyUsage=codeSigning"
      ${pkgs.openssl}/bin/openssl pkcs12 -export \
        -in "$tmp_dir/paneru.crt" \
        -inkey "$tmp_dir/paneru.key" \
        -out "$tmp_dir/paneru.p12" \
        -name "$cert_name" \
        -certpbe PBE-SHA1-3DES \
        -keypbe PBE-SHA1-3DES \
        -macalg sha1 \
        -passout pass:"$p12_password"
      /usr/bin/security import "$tmp_dir/paneru.p12" \
        -k "$keychain" \
        -P "$p12_password" \
        -T /usr/bin/codesign
    fi

    if /usr/bin/security find-certificate -c "$cert_name" -p "$keychain" > "$tmp_dir/paneru.crt"; then
      /usr/bin/security add-trusted-cert -d -r trustRoot -p codeSign -k "$keychain" "$tmp_dir/paneru.crt" >/dev/null 2>&1 || true
    fi

    /bin/rm -rf "$app_target"
    /bin/mkdir -p /Applications
    /bin/cp -R "$app_source" "$app_target"
    /usr/sbin/chown -R root:wheel "$app_target"
    /bin/chmod -R u+w "$app_target"
    /usr/bin/install -m 0644 "${paneruConfig}" "${stableConfigPath}"
    /usr/sbin/chown ${config.system.primaryUser}:staff "${stableConfigPath}"

    if ! /usr/bin/codesign --force --sign "$cert_name" --keychain "$keychain" "$app_target"; then
      echo "Failed to sign $app_target with '$cert_name'." >&2
      echo "Open Keychain Access, trust '$cert_name' for Code Signing, then run darwin-rebuild again." >&2
      exit 1
    fi

    /usr/bin/codesign --verify --verbose=2 "$app_target"
  '';
}
