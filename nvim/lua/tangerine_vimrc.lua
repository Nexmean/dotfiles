-- :fennel:1659477687
require("core")
require("core.options")
local _1_
do
  local core_utils = require("core.utils")
  local function _2_()
    return core_utils.load_mappings()
  end
  _1_ = _2_
end
vim.defer_fn(_1_, 0)
do
  local core_packer = require("core.packer")
  core_packer.bootstrap()
end
return require("plugins-new")