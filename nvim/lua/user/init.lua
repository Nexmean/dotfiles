NvimConfigDir = vim.fn.stdpath("config")

require("user.settings")
require("user.plugins")
require("user.settings_after")

require("user.commands")
require("user.autocommands")
vim.cmd("source " .. NvimConfigDir .. "/autocommands.vim")

-- Colorscheme tweaks and settings
require("user.colorscheme")

vim.schedule(function()
  require("user.lsp")
  vim.cmd("LspStart")
end)
