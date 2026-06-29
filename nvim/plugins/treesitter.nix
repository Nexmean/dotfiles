{
  config,
  lib,
  pkgs,
  ...
}:
let
  rev = "e413b1b57849a0097478548b25fcae2f3d0171d1";
  sysmlRev = "07a94a38c3090a0f730dc2b3ecdcd025d63226be";

  tree-sitter-quint = pkgs.tree-sitter.buildGrammar {
    language = "quint";
    version = "0-unstable-${builtins.substring 0 7 rev}";

    src = pkgs.fetchFromGitHub {
      owner = "gruhn";
      repo = "tree-sitter-quint";
      inherit rev;
      hash = "sha256-WVSRFaj+X/S4DgyA6nWmRO+99iWG9Tr5hVrj53VB8E4=";
    };

    meta.homepage = "https://github.com/gruhn/tree-sitter-quint";
  };

  tree-sitter-sysml = pkgs.tree-sitter.buildGrammar {
    language = "sysml";
    version = "0.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "nomograph-ai";
      repo = "tree-sitter-sysml";
      rev = sysmlRev;
      hash = "sha256-HoocmrFwYyYCuH+1b4X2uYMz1+D7q1jMZlExebwWT/A=";
    };

    meta.homepage = "https://github.com/nomograph-ai/tree-sitter-sysml";
  };
in
{
  plugins.treesitter = {
    enable = true;

    grammarPackages = config.plugins.treesitter.package.allGrammars ++ [
      tree-sitter-quint
      tree-sitter-sysml
    ];

    languageRegister.quint = "quint";
    languageRegister.sysml = "sysml";

    settings = {
      highlight.enable = lib.mkDefault true;
      indent.enable = lib.mkDefault true;
    };
  };

  extraPlugins = [
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
