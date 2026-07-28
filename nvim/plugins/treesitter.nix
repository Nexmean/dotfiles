{
  config,
  lib,
  nvimInputs,
  pkgs,
  ...
}:
let
  tree-sitter-likec4 = pkgs.tree-sitter.buildGrammar {
    language = "likec4";
    version = "0-unstable-${nvimInputs.tree-sitter-likec4.shortRev}";
    src = nvimInputs.tree-sitter-likec4;

    meta.homepage = "https://github.com/kremovtort/tree-sitter-likec4";
  };

  tree-sitter-quint = pkgs.tree-sitter.buildGrammar {
    language = "quint";
    version = "0-unstable-${nvimInputs.tree-sitter-quint.shortRev}";
    src = nvimInputs.tree-sitter-quint;

    meta.homepage = "https://github.com/gruhn/tree-sitter-quint";
  };

  tree-sitter-sysml = pkgs.tree-sitter.buildGrammar {
    language = "sysml";
    version = "0.1.0";
    src = nvimInputs.tree-sitter-sysml;

    meta.homepage = "https://github.com/nomograph-ai/tree-sitter-sysml";
  };
in
{
  plugins.treesitter = {
    enable = true;

    grammarPackages = config.plugins.treesitter.package.allGrammars ++ [
      tree-sitter-likec4
      tree-sitter-quint
      tree-sitter-sysml
    ];

    languageRegister.likec4 = "likec4";
    languageRegister.quint = "quint";
    languageRegister.sysml = "sysml";

    settings = {
      highlight.enable = lib.mkDefault true;
      indent.enable = lib.mkDefault true;
    };
  };

  extraPlugins = [
    tree-sitter-likec4
    tree-sitter-quint
    tree-sitter-sysml
  ];

  filetype.extension.qnt = "quint";
  filetype.extension.sysml = "sysml";

  plugins.treesitter-context = {
    enable = lib.mkDefault true;
    settings.on_attach.__raw = ''
      function(buf)
        return vim.bo[buf].buftype ~= "nofile"
      end
    '';
  };

  colorschemes.catppuccin.settings.integrations.treesitter_context.enable = lib.mkDefault true;

  plugins.ts-context-commentstring.enable = true;
}
