-- :fennel:1659180777
local function _1_()
  vim.g.haskell_enable_quanitification = 1
  vim.g.haskell_enable_recursivedo = 1
  vim.g.haskell_enable_arrowsyntax = 1
  vim.g.haskell_enable_pattern_synonyms = 1
  vim.g.haskell_enable_typeroles = 1
  vim.g.haskell_enable_static_pointers = 1
  vim.g.haskell_backpack = 1
  vim.g.neovide_cursor_animation_length = 1
  vim.g.neovide_scroll_animation_length = 1
  vim.opt.guifont = "JetbrainsMono Nerd Font:h18"
  vim.o.sessionoptions = "buffers,curdir,folds,winpos,winsize"
  return nil
end
return {options = {user = _1_}, mappings = require("conf.mappings")}