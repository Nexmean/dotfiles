#!/usr/bin/env bash
set -euo pipefail

dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
release_json="$(mktemp)"
hashes_json="$(mktemp)"
trap 'rm -f "$release_json" "$hashes_json"' EXIT

curl -fsSL "https://api.github.com/repos/elan8/spec42/releases/latest" > "$release_json"

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

  # shellcheck disable=SC2016
  digest="$(RELEASE_JSON="$release_json" ASSET="$asset" nix eval --impure --raw --expr '
    let
      asset = builtins.getEnv "ASSET";
      release = builtins.fromJSON (builtins.readFile (builtins.getEnv "RELEASE_JSON"));
      matches = builtins.filter (candidate: candidate.name == asset) release.assets;
    in
      if matches == [] then throw "Missing release asset ${asset}" else (builtins.head matches).digest
  ')"

  [[ "$digest" == sha256:* ]] || {
    printf 'Unexpected digest for %s: %s\n' "$asset" "$digest" >&2
    exit 1
  }
  nix hash convert --hash-algo sha256 --to sri "${digest#sha256:}"
}

aarch64_darwin_hash="$(hash_for_asset "spec42-${version}-darwin-arm64.tar.gz")"
x86_64_darwin_hash="$(hash_for_asset "spec42-${version}-darwin-x64.tar.gz")"
x86_64_linux_hash="$(hash_for_asset "spec42-${version}-linux-x64.tar.gz")"

{
  printf '{\n  "version": "%s",\n  "hashes": {\n' "$version"
  printf '    "aarch64-darwin": "%s",\n' "$aarch64_darwin_hash"
  printf '    "x86_64-darwin": "%s",\n' "$x86_64_darwin_hash"
  printf '    "x86_64-linux": "%s"\n  }\n}\n' "$x86_64_linux_hash"
} > "$hashes_json"
mv "$hashes_json" "$dir/hashes.json"

printf 'Updated spec42 to %s in %s\n' "$version" "$dir/hashes.json"
