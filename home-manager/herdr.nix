{
  pkgs,
  inputs,
  lib,
  config,
  system,
  ...
}:
let
  herdr = inputs.llm-agents.packages.${system}.herdr;
  herdrWrapper = pkgs.writeShellScriptBin "herdr" ''
    set -euo pipefail

    if [[ -z "''${SSH_AUTH_SOCK:-}" ]]; then
      exec ${herdr}/bin/herdr "$@"
    fi

    if [[ $# -gt 0 && "''${1:-}" != "remote-client-bridge" ]]; then
      exec ${herdr}/bin/herdr "$@"
    fi

    session="default"
    args=("$@")
    for ((i = 1; i < ''${#args[@]}; i++)); do
      if [[ "''${args[$i]}" == "--session" && $((i + 1)) -lt ''${#args[@]} ]]; then
        session="''${args[$((i + 1))]}"
        break
      fi
    done

    sock_dir="$HOME/.ssh/herdr-agent"
    sock="$sock_dir/$session.sock"
    ${pkgs.coreutils}/bin/mkdir -p "$sock_dir"
    ${pkgs.coreutils}/bin/ln -sfn "$SSH_AUTH_SOCK" "$sock"

    SSH_AUTH_SOCK="$sock" exec ${herdr}/bin/herdr "$@"
  '';

  # Editor side of vim-herdr-navigation is fetched by the nvim flake; reuse the
  # same source for the herdr-side registration so both stay in lockstep.
  herdrNavigationSrc = inputs.nvim.inputs.plugins-vim-herdr-navigation;
in
{
  home.packages = [
    herdrWrapper
  ];

  # herdr config lives in the working tree (herdr/config.toml) and is linked
  # out-of-store so it stays editable in place while being tracked by VCS.
  # herdr writes config.toml in place (verified empirically), preserving the symlink.
  home.file.".config/herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/herdr/config.toml";

  # Register the herdr side of vim-herdr-navigation. herdr plugins live outside
  # the Nix profile, so gate registration by home-manager activation: unlink any
  # stale entry first (old Nix store path), then link the current source.
  home.activation.herdrNavigationPlugin = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${herdr}/bin/herdr plugin unlink vim-herdr-navigation 2>/dev/null || true
    $DRY_RUN_CMD ${herdr}/bin/herdr plugin link ${herdrNavigationSrc} || true
  '';
}
