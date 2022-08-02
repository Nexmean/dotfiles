-- :fennel:1659479994
local _var_1_ = require("core.lib")
local call = _var_1_["call"]
local function _2_()
  return (require("core.lazy_load")).gitsigns()
end
local function _3_()
  return (require("gitsigns")).setup({})
end
return {from = "lewis6991/gitsigns.nvim", ft = "gitcommit", setup = _2_, config = _3_}