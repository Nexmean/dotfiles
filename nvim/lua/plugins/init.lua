vim.cmd "packadd packer.nvim"

local plugins = {
   ["wbthomason/packer.nvim"] = {},
   ["nvim-lua/plenary.nvim"] = {},
   ["nvim-lua/popup.nvim"] = {},

   ------------------------- UI ------------------------- {{
   ["EdenEast/nightfox.nvim"] = {
      config = function()
         require("nightfox").setup {
            groups = {
               all = {
                  NvimTreeNormal = { fg = "fg1", bg = "bg1" },
                  TelescopeBorder = { bg = "bg0", fg = "bg0" },
                  TelescopeNormal = { bg = "bg0" },
                  ToggleTermFloatBorder = { bg = "bg0", fg = "bg0" },
               },
            },
         }

         vim.cmd "colorscheme duskfox"

         require("ui.colors").generate_user_config_highlights()
      end,
   },

   ["kyazdani42/nvim-web-devicons"] = {
      module = "nvim-web-devicons",
      config = function()
         require("plugins.configs.devicons").setup()
      end,
   },

   ["kyazdani42/nvim-tree.lua"] = {
      cmd = { "NvimTreeToggle", "NvimTreeFocus" },
      config = function()
         require "plugins.configs.nvimtree"
      end,
   },

   ["folke/trouble.nvim"] = {
      as = "trouble.nvim",
      module = "trouble",
      after = "nvim-web-devicons",
      cmd = "Trouble",
      config = function()
         require("trouble").setup {
            action_keys = {
               cancel = "<C-[>",
            },
         }
      end,
   },

   ["petertriho/nvim-scrollbar"] = {
      config = function()
         require("scrollbar").setup {}
      end,
   },

   -- Only load whichkey after all the gui
   ["folke/which-key.nvim"] = {
      module = "which-key",
      config = function()
         require "plugins.configs.whichkey"
      end,
   },

   ["nanozuki/tabby.nvim"] = {
      after = "nightfox.nvim",
      config = function()
         require "plugins.configs.tabby"
      end,
   },

   ["nvim-lualine/lualine.nvim"] = {
      requires = "kyazdani42/nvim-web-devicons",
      after = "nightfox.nvim",
      config = function()
         require("lualine").setup {
            options = {
               section_separators = { left = "", right = "█" },
               component_separators = { left = "", right = "" },
            },
            sections = {
               lualine_y = { "location" },
               lualine_z = {},
            },
         }
      end,
   },

   ["folke/zen-mode.nvim"] = {
      cmd = "ZenMode",
      config = function()
         require("zen-mode").setup {}
      end,
   },

   ["akinsho/toggleterm.nvim"] = {
      config = function()
         require "plugins.configs.toggleterm"
      end,
   },
   ------------------------- UI ------------------------- }}

   --------------------- TELESCOPE ---------------------- {{
   ["nvim-telescope/telescope.nvim"] = {
      cmd = "Telescope",
      requires = {
         "nvim-telescope/telescope-live-grep-args.nvim",
         "nvim-telescope/telescope-ui-select.nvim",
      },
      module = "telescope",
      after = "persisted.nvim",
      config = function()
         local telescope = require "telescope"
         telescope.load_extension "persisted"
         telescope.load_extension "live_grep_args"
         telescope.load_extension "ui-select"

         local config = require "plugins.configs.telescope"
         telescope.setup(config)
      end,
   },

   ["nvim-telescope/telescope-frecency.nvim"] = {
      requires = "tami5/sqlite.lua",
      after = "telescope.nvim",
      config = function()
         require("telescope").load_extension "frecency"
      end,
   },
   --------------------- TELESCOPE ---------------------- }}

   ------------------------ CMP ------------------------- {{
   ["rafamadriz/friendly-snippets"] = {
      module = "cmp_nvim_lsp",
      event = "InsertEnter",
   },

   ["hrsh7th/nvim-cmp"] = {
      after = "friendly-snippets",
      config = function()
         require "plugins.configs.cmp"
      end,
   },

   ["L3MON4D3/LuaSnip"] = {
      wants = "friendly-snippets",
      after = "nvim-cmp",
      config = function()
         require("plugins.configs.others").luasnip()
      end,
   },

   ["saadparwaiz1/cmp_luasnip"] = {
      after = "LuaSnip",
   },

   ["hrsh7th/cmp-nvim-lua"] = {
      after = "cmp_luasnip",
   },

   ["hrsh7th/cmp-nvim-lsp"] = {
      after = "cmp-nvim-lua",
   },

   ["hrsh7th/cmp-buffer"] = {
      after = "cmp-nvim-lsp",
   },

   ["hrsh7th/cmp-path"] = {
      after = "cmp-buffer",
   },
   ------------------------ CMP ------------------------- }}

   ------------------------ LSP ------------------------- {{
   ["williamboman/nvim-lsp-installer"] = {
      opt = true,
      cmd = require("core.lazy_load").lsp_cmds,
      setup = function()
         require("core.lazy_load").on_file_open "nvim-lsp-installer"
      end,
   },

   ["neovim/nvim-lspconfig"] = {
      after = "nvim-lsp-installer",
      module = "lspconfig",
      config = function()
         require "plugins.configs.lsp_installer"
         require "plugins.configs.lspconfig"
      end,
   },

   ["j-hui/fidget.nvim"] = {
      after = "nightfox.nvim",
      config = function()
         require("fidget").setup {}
      end,
   },
   ------------------------ LSP ------------------------- }}

   ------------------------ GIT ------------------------- {{
   ["lewis6991/gitsigns.nvim"] = {
      ft = "gitcommit",
      setup = function()
         require("core.lazy_load").gitsigns()
      end,
      config = function()
         require("plugins.configs.others").gitsigns()
      end,
   },

   ["sindrets/diffview.nvim"] = {
      requires = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons" },
      after = "plenary.nvim",
      module = "diffview",
      cmd = { "DiffviewOpen" },
      config = function()
         local options = require "plugins.configs.diffview"
         require("diffview").setup(options)
      end,
   },

   ["TimUntersberger/neogit"] = {
      requires = { "nvim-lua/plenary.nvim" },
      after = "diffview.nvim",
      cmd = "Neogit",
      module = "neogit",
      config = function()
         require("neogit").setup {
            disable_commit_confirmation = true,
            disable_context_highlighting = false,
            disable_insert_on_commit = false,
            integrations = {
               diffview = true,
            },
            signs = {
               section = { "", "" },
               item = { "", "" },
               hunk = { "", "" },
            },
         }
      end,
   },
   ------------------------ GIT ------------------------- }}

   ----------------------- EDITOR ----------------------- {{
   ["lukas-reineke/indent-blankline.nvim"] = {
      opt = true,
      setup = function()
         require("core.lazy_load").on_file_open "indent-blankline.nvim"
      end,
      config = function()
         require("plugins.configs.others").blankline()
      end,
   },

   ["nvim-treesitter/nvim-treesitter"] = {
      module = "nvim-treesitter",
      setup = function()
         require("core.lazy_load").on_file_open "nvim-treesitter"
      end,
      cmd = require("core.lazy_load").treesitter_cmds,
      run = ":TSUpdate",
      config = function()
         require "plugins.configs.treesitter"
      end,
   },

   ["windwp/nvim-autopairs"] = {
      after = "nvim-cmp",
      config = function()
         require("plugins.configs.others").autopairs()
      end,
   },

   ["numToStr/Comment.nvim"] = {
      module = "Comment",
      keys = { "gc" },
      config = function()
         require("plugins.configs.others").comment()
      end,
   },

   ["kylechui/nvim-surround"] = {
      config = function()
         require("nvim-surround").setup {}
      end,
   },

   ["phaazon/hop.nvim"] = {
      branch = "v2",
      config = function()
         require("hop").setup {}
      end,
   },

   ["mhartington/formatter.nvim"] = {
      cmd = { "Format", "FormatWrite" },
      config = function()
         require("formatter").setup {
            logging = true,
            log_level = vim.log.levels.WARN,
            filetype = {
               haskell = {
                  function()
                     return {
                        exe = "stylish-haskell",
                        stdin = true,
                     }
                  end,
               },
               lua = {
                  require("formatter.filetypes.lua").stylua,
               },
            },
         }
      end,
   },

   ["gpanders/editorconfig.nvim"] = {
      as = "editorconfig.nvim",
   },
   ----------------------- EDITOR ----------------------- }}

   ---------------------- TESTING ----------------------- {{
   ["NTBBloodbath/rest.nvim"] = {
      after = "plenary.nvim",
      config = function()
         require("rest-nvim").setup {
            -- Open request results in a horizontal split
            result_split_horizontal = false,
            -- Keep the http file buffer above|left when split horizontal|vertical
            result_split_in_place = false,
            -- Skip SSL verification, useful for unknown certificates
            skip_ssl_verification = true,
            -- Highlight request on run
            highlight = {
               enabled = true,
               timeout = 150,
            },
            result = {
               -- toggle showing URL, HTTP info, headers at top the of result window
               show_url = true,
               show_http_info = true,
               show_headers = true,
            },
            -- Jump to request line on run
            jump_to_request = false,
            env_file = ".env",
            custom_dynamic_variables = {},
            yank_dry_run = true,
         }
      end,
   },
   ---------------------- TESTING ----------------------- }}

   ---------------------- HASKELL ----------------------- {{
   ["neovimhaskell/haskell-vim"] = {
      ft = { "haskell", "cabal" },
   },
   ---------------------- HASKELL ----------------------- }}

   -- sessions
   ["olimorris/persisted.nvim"] = {
      as = "persisted.nvim",
      config = function()
         require("persisted").setup {
            autoload = true,
            use_git_branch = true,
            before_save = function()
               while vim.fn.bufname() == "NeogitStatus" or vim.fn.bufname() == "NeogitCommitView" do
                  if vim.fn.tabpagenr "$" == 1 then
                     pcall(vim.cmd, "tabnew")
                  else
                     pcall(vim.cmd, "tabclose")
                  end
               end
               pcall(vim.cmd, "bw NeogitStatus")
               pcall(vim.cmd, "bw NeogitCommitView")
            end,
         }
      end,
   },

   -- notes
   ["nvim-neorg/neorg"] = {
      ft = "norg",
      after = "nvim-treesitter", -- You may want to specify Telescope here as well
      config = function()
         require("neorg").setup {
            load = {
               ["core.defaults"] = {},
               ["core.norg.dirman"] = {
                  config = {
                     workspaces = {
                        work = "~/Notes/work",
                        home = "~/Notes/home",
                     },
                  },
               },
            },
         }
      end,
   },
}

require("core.packer").run(plugins)
