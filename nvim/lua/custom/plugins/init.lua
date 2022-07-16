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
      requires = "nvim-lua/plenary.nvim",
      cmd = "Neogit",
      module = "neogit",
      config = function ()
         require("neogit").setup {}
      end
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

   ["olimorris/persisted.nvim"] = {
      as = "persisted.nvim",
      after = "telescope.nvim",
      cmd = {"SessionLoad", "SessionSave", "SessionLoadLast", "SessionStart", "SessionStop", "SessionToggle"},
      module = "telescope._extensions.persisted",
      config = function ()
          require("persisted").setup()
      end
   },

   ["nvim-telescope/telescope-ui-select.nvim"] = {
      as = "telescope-ui-select.nvim",
      after = "telescope.nvim",
      module = "telescope._extensions.ui-select",
      fn = "vim.lsp.buf.code_action",
   },

   ["nvim-telescope/telescope-frecency.nvim"] = {
      requires = "tami5/sqlite.lua",
      module = "telescope._extensions.frecency",
   },
}
