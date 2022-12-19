return function()
  require("window-picker").setup({
    autoselect_one = true,
    include_current = false,
    use_winbar = "never",
    show_prompt = false,
    filter_rules = {
      -- filter using buffer options
      bo = {
        -- if the file type is one of following, the window will be ignored
        filetype = { "neo-tree", "neo-tree-popup", "notify" },

        -- if the buffer type is one of following, the window will be ignored
        buftype = { "terminal", "quickfix" },
      },
    },
    current_win_hl_color = '#89b4fa',
    other_win_hl_color = '#89b4fa',
    fg_color = '#191926',
  })
end
