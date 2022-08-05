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
      "c", "cpp",
      "bash",
      "haskell",
      "http",
      "javascript", "typescript",
      "json", "toml", "yaml",
      "lua", "fennel",
      "make",
      "markdown",
      "nix",
      "norg",
      "proto",
      "python",
      "rust",
      "sql",
   },
   highlight = {
      enable = true,
      use_languagetree = true,
   },
}

treesitter.setup(options)

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.api.nvim_create_autocmd({"BufReadPost", "FileReadPost"}, {
   pattern = "*",
   command = "normal zR",
})

