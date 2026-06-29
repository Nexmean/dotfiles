{
  description = "Neovim configuration flake (NixVim + Lua config)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tabterm = {
      url = "github:kremovtort/tabterm.nvim/testing";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixvim.follows = "nixvim";
    };

    spec42 = {
      url = "path:../spec42";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Plugins not in nixpkgs
    plugins-opencode-nvim = {
      url = "github:nickjvandyke/opencode.nvim";
      flake = false;
    };

    plugins-vcsigns-nvim = {
      url = "github:algmyr/vcsigns.nvim";
      flake = false;
    };

    plugins-vclib-nvim = {
      url = "github:algmyr/vclib.nvim";
      flake = false;
    };

    plugins-async-nvim = {
      url = "github:lewis6991/async.nvim";
      flake = false;
    };

    plugins-virtual-types-nvim = {
      url = "github:jubnzv/virtual-types.nvim";
      flake = false;
    };

    plugins-seeker-nvim = {
      url = "github:2KAbhishek/seeker.nvim";
      flake = false;
    };

    plugins-direnv-nvim = {
      url = "github:NotAShelf/direnv.nvim";
      flake = false;
    };

    plugins-cursortab-nvim = {
      url = "github:cursortab/cursortab.nvim";
      flake = false;
    };

    plugins-likec4-nvim = {
      url = "github:likec4/likec4.nvim";
      flake = false;
    };

    plugins-sidekick-nvim = {
      url = "github:rmarganti/sidekick.nvim/herdr";
      flake = false;
    };

    plugins-vim-maximizer = {
      url = "github:szw/vim-maximizer";
      flake = false;
    };

    plugins-vim-herdr-navigation = {
      url = "github:paulbkim-dev/vim-herdr-navigation";
      flake = false;
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixvim,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      lib = {
        mkNvim =
          {
            system,
            pkgs ? nixpkgs.legacyPackages.${system},
            extraModules ? [ ],
            extraSpecialArgs ? { },
          }:
          let
            nixvim' = nixvim.legacyPackages.${system};
          in
          nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = {
              imports = [
                ./config.nix
                ./plugins.nix
                inputs.tabterm.nixvimModules.default
              ]
              ++ extraModules;
            };
            extraSpecialArgs = {
              nvimInputs = inputs;
            }
            // extraSpecialArgs;
          };
      };

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          nixvim' = nixvim.legacyPackages.${system};

          nvim-unwrapped = self.lib.mkNvim { inherit system pkgs; };

          nvim4vscode-unwrapped = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = import ./vscode.nix;
          };
        in
        {
          default = nvim-unwrapped;
          nvim = nvim-unwrapped;

          nvim4vscode = pkgs.runCommand "nvim4vscode" { } ''
            mkdir -p $out/bin
            ln -s ${nvim4vscode-unwrapped}/bin/nvim $out/bin/nvim4vscode
          '';
        }
      );
    };
}
