{
  config,
  pkgs,
  lib,
  system,
  self,
  isLima,
  ...
}:
let
  isDarwin = system == "aarch64-darwin";
  userName = "Alexander Makarov";
  userEmail = "i@kremovtort.ru";
  darwinPkgs = map (lib.mkIf isDarwin) [
    pkgs.lima
    pkgs.monitorcontrol
    pkgs.swiftdefaultapps
  ];
in
{
  imports = [
    ./karabiner.nix
    ./sops.nix
    ./zsh.nix
    ./starship.nix
    ./wezterm.nix
    ./ghostty.nix
    ./herdr.nix
  ];

  home.username = "kremovtort";
  home.homeDirectory =
    if isDarwin then
      "/Users/kremovtort"
    else if isLima then
      "/home/kremovtort.linux"
    else
      "/home/kremovtort";
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";

  home.packages = [
    pkgs.ast-grep
    (pkgs.writeShellScriptBin "sg" ''
      ast-grep $@
    '')
    (lib.mkIf isDarwin (
      pkgs.writeShellScriptBin "lnx" ''
        container machine run \
          -e USER \
          -e LOGNAME \
          -e COLORTERM="$${COLORTERM:-}" \
          -e TERM \
          -e APPLE_CONTAINER_MACHINE=1
      ''
    ))
    pkgs.bash-language-server
    pkgs.bat
    pkgs.bottom
    pkgs.bun
    pkgs.devcontainer
    pkgs.devenv
    pkgs.docker
    pkgs.fd
    pkgs.gitu
    pkgs.gnumake
    pkgs.htop
    pkgs.hunk
    pkgs.hydra-check
    pkgs.jetbrains-mono
    pkgs.jiq
    pkgs.jless
    pkgs.jq
    pkgs.kind
    pkgs.kubectl
    pkgs.lumen
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.symbols-only
    pkgs.nixd
    pkgs.nixfmt
    pkgs.nodejs
    pkgs.nvim
    pkgs.nvim4vscode
    pkgs.ov
    pkgs.ripgrep
    pkgs.shellcheck
    pkgs.stow
    pkgs.tokei
    pkgs.tree-sitter
    pkgs.uv
    pkgs.zsh-completions
    pkgs.zsh-fast-syntax-highlighting
    pkgs.zsh-fzf-tab
  ]
  ++ darwinPkgs;

  home.file = {
    ".clickhouse-client".source = "${self}/clickhouse-client";
    ".config/opencode/themes/catppuccin-espresso.json".source =
      "${self}/catppuccin/opencode-theme-catppuccin-espresso.json";
    ".config/ov/config.yaml".source = "${self}/ov.yaml";
    ".npmrc".text = ''
      @vertis:registry=https://npm.yandex-team.ru/
    ''
    + lib.optionalString isDarwin ''
      prefix=/opt/homebrew
    '';
  };

  home.shell.enableZshIntegration = true;
  home.sessionPath = [
    # Prefer Home Manager's Nix profile (notably node/npm) over Homebrew shims.
    "${config.home.homeDirectory}/.nix-profile/bin"
    "/opt/homebrew/bin"
    "/codenv/arcadia"
    "${config.home.homeDirectory}/arcadia"
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.cargo/bin"
    "${config.home.homeDirectory}/.rd/bin"
    "${config.home.homeDirectory}/.npm-globals/bin"
    "${config.home.homeDirectory}/.bun/bin"
  ];
  home.sessionVariables = {
    ARC = "${config.home.homeDirectory}/arcadia";
    ARCADIA = "${config.home.homeDirectory}/arcadia";
    EDITOR = "nvim";
    VISUAL = "nvim";
    SANDBOX_TOKEN = "\$(cat ~/.ya_token 2> /dev/null || true)";
    DO_NOT_TRACK = "1";
    LC_ALL = "en_US.UTF-8";
    PAGER = "ov";
    MANPAGER = "ov";
    OPENCODE_API_KEY = "\$(cat ${config.sops.secrets.opencode-api-key.path})";
    SHELL = lib.mkIf (!isDarwin) "/home/kremovtort/.nix-profile/bin/zsh";
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = true;
      invert = true;
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
    options = {
      dark = true;
      navigate = true;

      # UI accents
      file-style = "bold #89b4fa";
      file-decoration-style = "none";
      # Ensure hunk headers show the starting line numbers (the @@ -a,b +c,d @@ part).
      # hunk-header-style = "line-number syntax";
      # hunk-header-file-style = "bold #89b4fa";
      # hunk-header-line-number-style = "bold #bac2de";
      # hunk-header-decoration-style = "#2c2c2c box";

      # Diff colors
      minus-style = "syntax #2a1f22";
      minus-emph-style = "syntax #3a232a";
      plus-style = "syntax #1f2a22";
      plus-emph-style = "syntax #25352a";
      # NOTE: delta 0.18.2 on nixpkgs currently panics when `zero-style`
      # is given a background color ("capacity overflow"), which breaks jjui
      # and any git/jj pager output. Keep it background-free.
      zero-style = "syntax";
      whitespace-error-style = "#f38ba8 reverse";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    config = {
      hide_env_diff = true;
    };
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
    historyWidget.command = "";
  };

  programs.git = {
    enable = true;
    settings.init.defaultBranch = "main";
    settings.user.name = userName;
    settings.user.email = userEmail;
  };

  programs.jjui = {
    enable = true;
    settings = {
      preview = {
        revision_command = [
          "util"
          "exec"
          "--"
          "bash"
          "-c"
          "jj show --git -r $change_id | delta --paging never"
        ];
        file_command = [
          "util"
          "exec"
          "--"
          "bash"
          "-c"
          "jj diff --git -r $change_id $file | delta --paging never"
        ];
      };
    };
  };

  programs.jujutsu = {
    enable = true;
    settings.user.name = userName;
    settings.user.email = userEmail;
    settings.revsets.log = "present(@) | ancestors(@, 16) | ancestors(@.., 16)";
    settings.ui.diff-editor = [
      "nvim"
      "-c"
      "DiffEditor $left $right $output"
    ];
  };

  programs.less.enable = true;
  programs.man.enable = true;

  programs.neovide = {
    enable = true;
    settings = {
      font = {
        normal = [ "JetbrainsMono Nerd Font" ];
        size = 12;
        title-hidden = true;
      };
    };
  };

  programs.nix-your-shell = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.nushell.enable = true;

  programs.tealdeer.enable = true;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
