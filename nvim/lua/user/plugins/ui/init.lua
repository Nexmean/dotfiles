return {
  "alpha",
  -- "feline",
  "lualine",
  "navbuddy",
  "neo-tree",
  "noice",
  "nvim-web-devicons",
  "spectre",
  "telescope",
  "winshift",

  { "nvim-lua/popup.nvim" },

  {
    "LukasPietzschmann/telescope-tabs",
    lazy = true,
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      show_preview = false,
    },
  },

  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require "notify"
      vim.notify.setup {
        top_down = false,
        timeout = 3000,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
      }
    end,
  },

  {
    "stevearc/dressing.nvim",
    config = function()
      local themes = require "telescope.themes"
      require("dressing").setup {
        input = {
          border = "single",
        },
        select = {
          telescope = themes.get_dropdown {
            layout_config = {
              height = 0.8,
              width = { 0.8, max = 80 },
            },
            borderchars = {
              prompt = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
              results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
              preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
            },
          },
        },
      }
    end,
  },

  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        show_help = false,
        show_keys = false,
        window = {
          border = "single",
        },
      }
    end,
  },

  {
    "mrjones2014/legendary.nvim",
    enabled = false,
    dependencies = "kkharji/sqlite.lua",
    config = function()
      require("legendary").setup {
        which_key = {
          auto_register = true,
        },
        select_prompt = "legendary",
      }
    end,
  },

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
    "kevinhwang91/nvim-hlslens",
    opts = {
      nearest_only = true,
    },
    config = function(_, opts)
      require("scrollbar.handlers.search").setup(opts)
    end,
  },

  {
    "utilyre/barbecue.nvim",
    enabled = false,
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "smiteshp/nvim-navic" },
      { "nvim-tree/nvim-web-devicons" },
    },
    config = true,
  },

  {
    "s1n7ax/nvim-window-picker",
    version = "v1.*",
    config = function()
      require("window-picker").setup {
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
      }
    end,
  },

  {
    "beauwilliams/focus.nvim",
    enabled = false,
    config = function()
      require("focus").setup {
        signcolumn = false,
        excluded_filetypes = { "", "neo-tree" },
        excluded_buftypes = { "neo-tree", "nofile", "prompt", "popup", "terminal" },
        quickfixheight = 15,
        width = 115,
        minwidth = 30,
      }
      vim.cmd [[FocusDisable]]
    end,
  },

  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup {
        ui = { border = "single" },
      }
    end,
  },
}
