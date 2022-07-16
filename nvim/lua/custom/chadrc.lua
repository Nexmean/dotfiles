local M = {}

-- make sure you maintain the structure of `core/default_config.lua` here,
M.options = {
   user = function ()
      vim.g.haskell_enable_quantification = 1
      vim.g.haskell_enable_recursivedo = 1
      vim.g.haskell_enable_arrowsyntax = 1
      vim.g.haskell_enable_pattern_synonyms = 1
      vim.g.haskell_enable_typeroles = 1
      vim.g.haskell_enable_static_pointers = 1
      vim.g.haskell_backpack = 1
      vim.g.neovide_cursor_animation_length = 0
      vim.g.neovide_scroll_animation_length = 0.3
      vim.opt.guifont = "JetbrainsMono Nerd Font:h18"
      vim.o.sessionoptions = "buffers,curdir,folds,winpos,winsize"
   end
}

local my_hl = require "custom.ui.neogit"

M.ui = {
   hl_add = my_hl,
}

M.plugins = {
   user = require "custom.plugins",
   override = require "custom.plugins.override",
   options = {
      lspconfig = {
         setup_lspconf = "custom.plugins.configs.lspconfig"
      },
   },
}

M.mappings = require("custom.mappings")

return M
