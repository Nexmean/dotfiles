-- :fennel:1659294912
local function _1_()
  local which_key = require("which-key")
  local utils = require("core.utils")
  local mappings = utils.load_config().mappings
  local mapping_groups = {groups = vim.deepcopy(mappings.groups)}
  mappings.disabled = nil
  mappings.groups = nil
  utils.load_mappings(mapping_groups)
  return which_key.setup({icons = {breadcrumb = "\194\187", separator = " \239\149\147 ", group = "+"}, popup_mappings = {scroll_down = "<c-d>", scroll_up = "<c-u>"}, window = {border = "none"}, layout = {spacing = 6}, hidden = {"<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, triggers_blacklist = {i = {"j", "k"}, v = {"j", "k"}}})
end
return {from = "folke/which-key.nvim", module = "which-key", config = _1_}