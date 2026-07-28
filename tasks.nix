{ pkgs }:
let
  commonTasks = {
    "switch:home" = {
      desc = "Apply the home-manager configuration";
      cmds = [ "nix run .#home-manager -- switch --flake ." ];
    };

    update = {
      desc = "Update binaries and flake inputs";
      deps = [
        "update:opencode-vim"
        "update:flakes"
      ];
    };

    "update:flakes" = {
      desc = "Update all flake inputs";
      cmds = [
        "nix flake update --flake ./agents"
        "nix flake update --flake ./nvim"
        "nix flake update --flake ."
      ];
    };

    "update:opencode-vim" = {
      desc = "Update opencode-vim release hashes";
      cmds = [ "./agents/opencode-vim/update.sh" ];
    };

    "switch:shell" = {
      desc = "Configure the Nix profile zsh as the login shell on Linux";
      cmds = [
        ''
          if [ ! -d "/etc/nixos" ] && [ "$(uname)" != "Darwin" ]; then
            if ! grep -qx "''${HOME}/.nix-profile/bin/zsh" /etc/shells; then
              echo "''${HOME}/.nix-profile/bin/zsh" | sudo tee -a /etc/shells
            fi
            sudo chsh -s "''${HOME}/.nix-profile/bin/zsh" "''${USER}"
          fi
        ''
      ];
    };
  }
  // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
    "switch:darwin" = {
      desc = "Apply the nix-darwin configuration";
      cmds = [ "sudo nix run .#darwin-rebuild -- switch --flake ." ];
    };
  };

  switchTask = {
    desc = "Apply all configurations";
    cmds = pkgs.lib.optionals pkgs.stdenv.isDarwin [ { task = "switch:darwin"; } ] ++ [
      { task = "switch:home"; }
      { task = "switch:shell"; }
    ];
  };

  upgradeCommands = [
    { task = "update"; }
    { task = "switch"; }
  ]
  ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
    "brew update"
    "brew upgrade"
  ];
in
{
  tasks = commonTasks // {
    switch = switchTask;
    upgrade = {
      desc = "Update dependencies and apply all configurations";
      cmds = upgradeCommands;
    };
  };
}
