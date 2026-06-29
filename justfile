[macos]
darwin-rebuild-switch:
  sudo nix run .#darwin-rebuild -- switch --flake .

home-manager-switch:
  nix run .#home-manager -- switch --flake .

update: update-opencode-vim update-spec42 update-flakes

update-flakes:
  nix flake update --flake ./spec42
  nix flake update --flake ./agents
  nix flake update --flake ./nvim
  nix flake update --flake .

[linux]
switch: home-manager-switch setup-shell

[macos]
switch TARGET="":
  #!/usr/bin/env bash
  if [[ -z "{{TARGET}}" ]]; then
    just darwin-rebuild-switch
    just home-manager-switch
  elif [[ "{{TARGET}}" == "home" ]]; then
    just home-manager-switch
  elif [[ "{{TARGET}}" == "darwin" ]]; then
    just darwin-rebuild-switch
  fi
  just setup-shell

[linux]
upgrade: update-opencode-vim update-spec42 update-flakes
  just switch

[macos]
upgrade: update-opencode-vim update-spec42 update-flakes
  just switch
  brew update
  brew upgrade

update-opencode-vim:
  #!/usr/bin/env bash
  set -euo pipefail

  hashes_file="agents/opencode-vim/hashes.json"
  release_json="$(mktemp)"
  hashes_json="$(mktemp)"
  trap 'rm -f "$release_json" "$hashes_json"' EXIT

  curl -fsSL "https://api.github.com/repos/leohenon/opencode-vim/releases/latest" > "$release_json"

  version="$(RELEASE_JSON="$release_json" nix eval --impure --raw --expr '
    let
      release = builtins.fromJSON (builtins.readFile (builtins.getEnv "RELEASE_JSON"));
      tag = release.tag_name;
    in
      if builtins.substring 0 1 tag == "v" then builtins.substring 1 (builtins.stringLength tag - 1) tag else tag
  ')"

  hash_for_asset() {
    local asset="$1"
    local digest

    digest="$(RELEASE_JSON="$release_json" ASSET="$asset" nix eval --impure --raw --expr '
      let
        asset = builtins.getEnv "ASSET";
        release = builtins.fromJSON (builtins.readFile (builtins.getEnv "RELEASE_JSON"));
        matches = builtins.filter (candidate: candidate.name == asset) release.assets;
      in
        if matches == [] then throw "Missing release asset ${asset}" else (builtins.head matches).digest
    ')"

    if [[ "$digest" != sha256:* ]]; then
      printf 'Unexpected digest for %s: %s\n' "$asset" "$digest" >&2
      exit 1
    fi

    nix hash convert --hash-algo sha256 --to sri "${digest#sha256:}"
  }

  aarch64_darwin_hash="$(hash_for_asset "ocv-darwin-arm64")"
  x86_64_darwin_hash="$(hash_for_asset "ocv-darwin-x64")"
  aarch64_linux_hash="$(hash_for_asset "ocv-linux-arm64")"
  x86_64_linux_hash="$(hash_for_asset "ocv-linux-x64")"

  printf '{\n' > "$hashes_json"
  printf '  "version": "%s",\n' "$version" >> "$hashes_json"
  printf '  "hashes": {\n' >> "$hashes_json"
  printf '    "aarch64-darwin": "%s",\n' "$aarch64_darwin_hash" >> "$hashes_json"
  printf '    "x86_64-darwin": "%s",\n' "$x86_64_darwin_hash" >> "$hashes_json"
  printf '    "aarch64-linux": "%s",\n' "$aarch64_linux_hash" >> "$hashes_json"
  printf '    "x86_64-linux": "%s"\n' "$x86_64_linux_hash" >> "$hashes_json"
  printf '  }\n' >> "$hashes_json"
  printf '}\n' >> "$hashes_json"

  mv "$hashes_json" "$hashes_file"

  printf 'Updated opencode-vim to %s in %s\n' "$version" "$hashes_file"

update-spec42:
  ./spec42/update.sh

setup-shell:
  #!/usr/bin/env sh
  if [ ! -d "/etc/nixos" ] && [ "$(uname)" != "Darwin" ]; then
    if ! grep -qx "${HOME}/.nix-profile/bin/zsh" /etc/shells; then
      echo "${HOME}/.nix-profile/bin/zsh" | sudo tee -a /etc/shells
    fi
    sudo chsh -s "${HOME}/.nix-profile/bin/zsh" "${USER}"
  fi
