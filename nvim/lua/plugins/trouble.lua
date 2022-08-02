-- :fennel:1659300046
local function _1_()
  local trouble = require("trouble")
  return trouble.setup({action_keys = {cancel = "<C-[>"}})
end
return {from = "folke/trouble.nvim", after = "nvim-web-devicons", cmd = {"Trouble", "TroubleToggle"}, config = _1_}