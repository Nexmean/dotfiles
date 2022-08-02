-- :fennel:1659206578
local function _1_()
  local present_3f, devicons = pcall(require, "nvim-web-devicons")
  if present_3f then
    return devicons.setup({override = require("ui.icons")})
  else
    return nil
  end
end
return {setup = _1_}