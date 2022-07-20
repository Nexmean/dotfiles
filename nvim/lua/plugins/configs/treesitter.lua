local present, treesitter = pcall(require, "nvim-treesitter.configs")

if not present then
   return
end

require("base46").load_highlight "syntax"
require("base46").load_highlight "treesitter"

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
parser_configs.haskell = {
  install_info = {
    url = "~/.dotfiles/deps/tree-sitter-haskell",
    files = {"src/parser.c", "src/scanner.c"}
  }
}

local options = {
   ensure_installed = {
      "lua",
      "haskell",
   },
   highlight = {
      enable = true,
      use_languagetree = true,
   },
}

treesitter.setup(options)
