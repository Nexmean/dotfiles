-- :fennel:1659207282
local function _1_()
  local nightfox = require("nightfox")
  local ui_colors = require("ui.colors")
  nightfox.setup({groups = {all = {NvimTreeNormal = {fg = "fg1", bg = "bg1"}, TelescopeNormal = {bg = "bg0"}, TelescopeBorder = {bg = "bg0", fg = "bg0"}}}})
  vim.cmd("colorscheme duskfox")
  return ui_colors.generate_user_config_highlights()
end
return {from = "EdenEast/nightfox.nvim", config = _1_}