return {
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = true,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        sync_install = false,
        ensure_installed = "all",
        highlight = { enable = true },
        -- indent = { enable = true },
        context_commentstring = { enable = true, enable_autocmd = false },
      }
    end,
  },

  { "JoosepAlviste/nvim-ts-context-commentstring" },

  {
    "nvim-treesitter/playground",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  {
    "p00f/nvim-ts-rainbow",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup {
        rainbow = {
          enable = false,
          extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
          max_file_lines = 3000, -- Do not enable for files with more than 1000 lines, int
          colors = {
            "#bf616a",
            "#d08770",
            "#ebcb8b",
            "#a3be8c",
            "#88c0d0",
            "#5e81ac",
            "#b48ead",
          },
        },
      }
    end,
  },
}
