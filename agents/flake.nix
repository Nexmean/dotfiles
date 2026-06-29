{
  description = "OpenCode configuration flake (home-manager module + assets)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spec42 = {
      url = "path:../spec42";
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

    quintLlmKit = {
      url = "github:quint-co/quint-llm-kit";
      flake = false;
    };

    sysmlv2Skill = {
      url = "github:DeciSym/sysmlv2-skill";
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
      mkHomeModule =
        system:
        let
          spec42 = inputs.spec42.packages.${system}.default or null;
        in
        {
          _module.args.agentsInputs = inputs;
          _module.args.agents = self;
          _module.args.system = system;

          imports = [
            ./opencode.nix
            ./openspec.nix
          ];

          home.packages =
            (with inputs.llm-agents.packages.${system}; [
              codegraph
              jscpd
              openspec
              qmd
              inputs.crit.packages.${system}.default
            ])
            ++ inputs.nixpkgs.lib.optional (spec42 != null) spec42;
        };
    in
    {
      homeModules = builtins.mapAttrs (system: _: {
        default = mkHomeModule system;
      }) inputs.llm-agents.packages;
    };
}
