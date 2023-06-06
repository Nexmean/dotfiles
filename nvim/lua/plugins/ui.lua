return {
  {
    "petertriho/nvim-scrollbar",
    opts = {
      -- show_in_active_only = true,
      excluded_filetypes = { "prompt", "TelescopePrompt", "neo-tree", "lazy" },
      marks = {
        Cursor = {
          text = " ",
          priority = 100,
        },
        Search = { text = { "", "" }, highlight = "ScrollbarIncSearch" },
        Error = { text = { "", "" } },
        Warn = { text = { "", "" } },
        Info = { text = { "", "" } },
        Hint = { text = { "", "" } },
      },
    },
  },

  {
    "utilyre/barbecue.nvim",
    -- enabled = false,
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "SmiteshP/nvim-navic" },
      { "nvim-tree/nvim-web-devicons" },
    },
    opts = {
      show_navic = false,
    },
  },

  {
    "s1n7ax/nvim-window-picker",
    version = "v1.*",
    opts = {
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
      current_win_hl_color = "#89b4fa",
      other_win_hl_color = "#89b4fa",
      fg_color = "#191926",
    },
  },
}
