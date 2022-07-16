return {
   ["neovimhaskell/haskell-vim"] = {
      ft = {'haskell', 'cabal'},
   },

   ["kylechui/nvim-surround"] = {
      config = function ()
         require('nvim-surround').setup {}
      end,
   },

   ["phaazon/hop.nvim"] = {
      branch = "v2",
      config = function ()
         require("hop").setup { keys = 'etovxqpdygfblzhckisuran' }
      end
   },

   ["folke/trouble.nvim"] = {
      as = "trouble.nvim",
      module = "trouble",
      after = "nvim-web-devicons",
      cmd = "Trouble",
      config = function ()
         require("trouble").setup {
            action_keys = {
               cancel = "<C-[>"
            }
         }
      end
   },

   ["petertriho/nvim-scrollbar"] = {
      config = function ()
         require("scrollbar").setup {}
      end
   },

   ["TimUntersberger/neogit"] = {
      requires = { "nvim-lua/plenary.nvim" },
      after = { "base46" },
      cmd = "Neogit",
      module = "neogit",
      config = function ()
         require("neogit").setup {
            disable_commit_confirmation = true,
            disable_context_highlighting = false,
            signs = {
                section = { "", "" },
                item = { "", "" },
                hunk = { "", "" },
            },
         }
      end,
   },

   ["mhartington/formatter.nvim"] = {
      cmd = {"Format", "FormatWrite"},
      config = function ()
         require("formatter").setup {
            logging = true,
            log_level = vim.log.levels.WARN,
            filetype = {
               haskell = {
                  function ()
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
      as = "editorconfig.nvim"
   },


   ["nvim-telescope/telescope-ui-select.nvim"] = {
      as = "telescope-ui-select.nvim",
      after = "telescope.nvim",
      module = "telescope._extensions.ui-select",
      fn = "vim.lsp.buf.code_action",
   },

   ["olimorris/persisted.nvim"] = {
      as = "persisted.nvim",
      config = function ()
         require("persisted").setup {
            autoload = true,
            use_git_branch = true,
         }
      end,
   },

   ["nvim-telescope/telescope-frecency.nvim"] = {
      requires = "tami5/sqlite.lua",
      module = "telescope._extensions.frecency",
   },
}
