local present, treesitter = pcall(require, "nvim-treesitter.configs")

if not present then
   return
end

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
