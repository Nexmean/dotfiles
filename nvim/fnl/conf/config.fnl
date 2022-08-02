{
  :options {
    :user (fn []
      (set vim.g.haskell_enable_quanitification  1)
      (set vim.g.haskell_enable_recursivedo      1)
      (set vim.g.haskell_enable_arrowsyntax      1)
      (set vim.g.haskell_enable_pattern_synonyms 1)
      (set vim.g.haskell_enable_typeroles        1)
      (set vim.g.haskell_enable_static_pointers  1)
      (set vim.g.haskell_backpack                1)

      (set vim.g.neovide_cursor_animation_length 1)
      (set vim.g.neovide_scroll_animation_length 1)

      (set vim.opt.guifont "JetbrainsMono Nerd Font:h18")

      (set vim.o.sessionoptions "buffers,curdir,folds,winpos,winsize")
    )
  }

  :mappings (require :conf.mappings) 
}

