-- :fennel:1659480465
local _var_1_ = require("core.lib")
local call = _var_1_["call"]
local function _2_()
  return (require("telescope")).load_extension("frecency")
end
return {from = "nvim-telescope/telescope-frecency.nvim", requires = "tami5/sqlite.lua", after = "telescope", config = _2_}