-- :fennel:1659304648
local function _1_()
  local neorg = require("neorg")
  return neorg.setup({load = {["core.defaults"] = {}, ["core.norg.dirman"] = {workspaces = {work = "~/Notes/work", home = "~/Notes/home"}}}})
end
return {from = "nvim-neorg/neorg", ft = "norg", after = "nvim-treesitter", config = _1_}