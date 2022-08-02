-- :fennel:1659479948
local _var_1_ = require("core.lib")
local call = _var_1_["call"]
local function _2_()
  return (require("core.lazy_load")).on_file_open("nvim-lsp-installer")
end
local function _3_()
  local lsp_installer = require("nvim-lsp-installer")
  return lsp_installer.setup({automatic_installation = {exclude = {"hls"}}, ui = {icons = {server_installed = "\239\152\178 ", server_pending = "\239\134\146 ", server_uninstalled = "\239\174\138 "}, keymaps = {toggle_server_expand = "<CR>", install_server = "i", update_server = "u", check_server_version = "c", update_all_servers = "U", check_outdated_servers = "C", uninstall_server = "X"}}, max_concurrent_installer = 10})
end
return {from = "williamboman/nvim-lsp-installer", opt = true, cmd = (require("core.lazy_load")).lsp_cmds, setup = _2_, config = _3_}