-- :fennel:1659207673
local function _1_()
  local present_3f, devicons = pcall(require, "nvim-web-devicons")
  if present_3f then
    return devicons.setup({override = require("ui.icons")})
  else
    return nil
  end
end
return {from = "kyazdani42/nvim-web-devicons", module = "nvim-web-devicons", config = _1_}