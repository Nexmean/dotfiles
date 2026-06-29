{
  description = "OpenCode configuration flake (home-manager module + assets)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    astGrepSkill = {
      url = "github:ast-grep/agent-skill";
      flake = false;
    };

    openaiSkills = {
      url = "github:openai/skills";
      flake = false;
    };

    qmd = {
      url = "github:tobi/qmd";
      flake = false;
    };

    crit = {
      url = "github:tomasz-tomczyk/crit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    openspecSchemas = {
      url = "github:intent-driven-dev/openspec-schemas";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      ...
    }:
    let
      mkHomeModule = system: {
        _module.args.agentsInputs = inputs;
        _module.args.agents = self;
        _module.args.system = system;

        imports = [
          ./opencode.nix
          ./openspec.nix
        ];

        home.packages = with inputs.llm-agents.packages.${system}; [
          codegraph
          openspec
          qmd
          inputs.crit.packages.${system}.default
        ];
      };
    in
    {
      homeModules = builtins.mapAttrs (system: _: {
        default = mkHomeModule system;
      }) inputs.llm-agents.packages;
    };
}
