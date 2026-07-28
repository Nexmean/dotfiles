{
  description = "OpenCode configuration flake (home-manager module + assets)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mattPocockSkills = {
      url = "github:mattpocock/skills";
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
        ];

        home.packages = (
          with inputs.llm-agents.packages.${system};
          [
            beads-rust
            beads-viewer
            codegraph
            jscpd
            qmd
          ]
        );
      };
    in
    {
      homeModules = builtins.mapAttrs (system: _: {
        default = mkHomeModule system;
      }) inputs.llm-agents.packages;
    };
}
