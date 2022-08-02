-- :fennel:1659480440
local _var_1_ = require("core.lib")
local call = _var_1_["call"]
local function _2_()
  return (require("telescope")).load_extension("ui-select")
end
return {from = "nvim-telescope/telescope-ui-select.nvim", after = "telescope", fn = "vim.lsp.buf.code_action", config = _2_}