{
  autoPatchelfHook,
  fetchurl,
  lib,
  stdenv,
}:
let
  versionData = builtins.fromJSON (builtins.readFile ./hashes.json);
  inherit (versionData) version hashes;

  platformMap = {
    aarch64-darwin = "darwin-arm64";
    x86_64-darwin = "darwin-x64";
    x86_64-linux = "linux-x64";
  };
  system = stdenv.hostPlatform.system;
  platform = platformMap.${system} or (throw "Unsupported spec42 system: ${system}");
in
stdenv.mkDerivation {
  pname = "spec42";
  inherit version;

  src = fetchurl {
    url = "https://github.com/elan8/spec42/releases/download/v${version}/spec42-${version}-${platform}.tar.gz";
    hash = hashes.${system} or (throw "Missing spec42 hash for ${system}");
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  dontConfigure = true;
  dontBuild = true;
  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    tar -xzf $src -C $out/bin
    runHook postInstall
  '';

  meta = {
    description = "SysML v2 and KerML language tooling";
    homepage = "https://github.com/elan8/spec42";
    license = lib.licenses.mit;
    mainProgram = "spec42";
    platforms = builtins.attrNames platformMap;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
