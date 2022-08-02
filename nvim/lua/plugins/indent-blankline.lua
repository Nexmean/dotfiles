-- :fennel:1659480120
local _var_1_ = require("core.lib")
local call = _var_1_["call"]
local function _2_()
  return (require("core.lazy_load")).on_file_open("indent-blankline")
end
local function _3_()
  local blankline = require("indent_blankline")
  return blankline.setup({filetype_exclude = {"help", "terminal", "alpha", "packer", "lspinfo", "TelescopePrompt", "TelescopeResults", "lsp-installer", ""}, buftype_exclude = {"terminal"}, indentLine_enabled = 1, show_current_context = true, show_current_context_start = true, show_first_indent_level = false, show_trailing_blankline_indent = false})
end
return {from = "lukas-reineke/indent-blankline.nvim", opt = true, setup = _2_, config = _3_}