-- :fennel:1659300498
local function _1_()
  local formatter = require("formatter")
  local function _2_()
    return {exe = "stylish-haskell", stdin = true}
  end
  return formatter.setup({logging = true, log_level = vim.log.levels.WARN, filetype = {haskell = {_2_}, lua = {(require("formatter.filetypes.lua")).stylua}}})
end
return {from = "mhartington/formatter.nvim", cmd = {"Format", "FormatWrite"}, config = _1_}