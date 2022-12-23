NvimConfigDir = vim.fn.stdpath("config")

-- vim.cmd("source " .. NvimConfigDir .. "/mappings.vim")
require("user.settings")
require("user.plugins")
require("user.settings_after")
require("user.mappings").load()
require("user.commands")
vim.cmd("source " .. NvimConfigDir .. "/autocommands.vim")

-- Colorscheme tweaks and settings
require("user.colorscheme")

vim.schedule(function()
  require("user.lsp")
  vim.cmd("LspStart")
end)
