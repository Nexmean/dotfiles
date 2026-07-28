{
  description = "My macos system Nix flake";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    karabinix.url = "github:pepegar/karabinix";
    jj-starship.url = "github:dmmulroy/jj-starship";

    nix-task = {
      url = "github:kremovtort/nix-task";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    paneru = {
      url = "github:karinushka/paneru";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "nix-darwin";
      inputs.flake-parts.follows = "flake-parts";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim = {
      url = "path:./nvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixvim.inputs.nixpkgs.follows = "nixpkgs";
    };

    agents = {
      url = "path:./agents";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      perSystem =
        {
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              (final: prev: {
                nvim = inputs.nvim.packages.${prev.stdenv.hostPlatform.system}.default;
                nvim4vscode = inputs.nvim.packages.${prev.stdenv.hostPlatform.system}.nvim4vscode;
                jj-starship = inputs.jj-starship.packages.${prev.stdenv.hostPlatform.system}.default;
              })
            ];
            config = { };
          };
          packages.home-manager = inputs'.home-manager.packages.home-manager;
          packages.darwin-rebuild = inputs'.nix-darwin.packages.darwin-rebuild;

          devShells.default = pkgs.mkShell {
            inputsFrom = [
              (inputs.nix-task.lib.${system}.mkTasks (import ./tasks.nix { inherit pkgs; }))
            ];

            packages = [
              pkgs.bash-language-server
              pkgs.lua
              pkgs.lua-language-server
              pkgs.nixd
              pkgs.nixfmt
              pkgs.statix
              pkgs.shellcheck
              pkgs.stylua
            ];
          };

          legacyPackages.homeConfigurations."kremovtort" = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              inputs.agents.homeModules.${system}.default
              ./home-manager/home.nix
            ];
            extraSpecialArgs = {
              inherit system inputs self;
              isLima = false;
            };
          };

          legacyPackages.homeConfigurations."kremovtort@lima-default" =
            inputs.home-manager.lib.homeManagerConfiguration
              {
                inherit pkgs;
                modules = [
                  inputs.agents.homeModules.${system}.default
                  ./home-manager/home.nix
                ];
                extraSpecialArgs = {
                  inherit system inputs self;
                  isLima = true;
                };
              };

          legacyPackages.darwinConfigurations."kremovtort-OSX" = inputs.nix-darwin.lib.darwinSystem {
            specialArgs = { inherit inputs self; };
            modules = [ ./darwin/configuration.nix ];
          };
        };
    }
    // {
      lib.mkNvim = inputs.nvim.lib.mkNvim;
    };
}
