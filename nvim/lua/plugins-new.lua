-- :fennel:1659478084
vim.cmd("packadd packer.nvim")
local _var_1_ = require("plugins.lib.packer")
local load_configs = _var_1_["load-configs"]
local _var_2_ = require("core.packer")
local packer_run = _var_2_["run_new"]
local plugins = load_configs({{"packer", {as = "packer.nvim"}}, {"tangerine", {as = "tangerine.nvim"}}, "plenary", "Comment", "editorconfig", "formatter", "friendly-snippets", "hop", "nvim-autopairs", "nvim-surround", "indent-blankline", "nvim-treesitter", "cmp", "fidget", "nvim-lsp-installer", "nvim-lspconfig", "trouble", "diffview", "gitsigns", "lualine", "nightfox", "nvim-scrollbar", "nvim-tree", "nvim-web-devicons", "tabby", "telescope", "telescope-frecency", "telescope-ui-select", "which-key", "haskell-vim", "neorg", "persisted"})
return packer_run(plugins)