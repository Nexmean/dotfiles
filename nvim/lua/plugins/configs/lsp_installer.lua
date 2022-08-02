-- :fennel:1659136129
local present_3f, lsp_installer = pcall(require, "nvim-lsp-installer")
if present_3f then
  return lsp_installer.setup({automatic_installation = {exclude = {"hls"}}, ui = {icons = {server_installed = "\239\152\178 ", server_pending = "\239\134\146 ", server_uninstalled = "\239\174\138 "}, keymaps = {toggle_server_expand = "<CR>", install_server = "i", update_server = "u", check_server_version = "c", update_all_servers = "U", check_outdated_servers = "C", uninstall_server = "X"}}, max_concurrent_installer = 10})
else
  return nil
end