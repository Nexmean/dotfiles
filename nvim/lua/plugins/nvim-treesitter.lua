-- :fennel:1659479605
local _var_1_ = require("core.lib")
local call = _var_1_["call"]
local function _2_()
  return (require("core.lazy_load")).on_file_open("nvim-treesitter")
end
local function _3_()
  local treesitter = require("nvim-treesitter.configs")
  local parser_configs = (require("nvim-treesitter.parsers")).get_parser_configs()
  do end (parser_configs)["haskell"] = {install_info = {url = "~/.dotfiles/deps/tree-sitter-haskell", files = {"src/parser.c", "src/scanner.c"}}}
  treesitter.setup({ensure_installed = {"c", "cpp", "bash", "haskell", "javascript", "typescript", "json", "toml", "yaml", "lua", "fennel", "make", "markdown", "nix", "norg", "proto", "python", "rust", "sql"}, highlight = {enable = true, use_languagetree = true}, rainbow = {enable = true}})
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  return vim.api.nvim_create_autocmd({"BufReadPost", "FileReadPost"}, {pattern = "*", command = "normal zR"})
end
return {from = "nvim-treesitter/nvim-treesitter", module = "nvim-treesitter", setup = _2_, cmd = {"TSInstall", "TSBufEnable", "TSBufDisable", "TSEnable", "TSDisable", "TSModuleInfo"}, run = "TSUpdate", config = _3_}