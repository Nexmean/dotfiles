-- :fennel:1659479685
local function _1_()
  local lualine = require("lualine")
  return lualine.setup({options = {section_separators = {left = "\238\130\188", right = "\226\150\136"}, component_separators = {left = "\238\130\189", right = ""}}, sections = {lualine_y = {"location"}, lualine_z = {}}})
end
return {from = "nvim-lualine/lualine.nvim", after = "nightfox", config = _1_}