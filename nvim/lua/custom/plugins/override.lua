return {
   ["kyazdani42/nvim-tree.lua"] = {
      git = {
         enable = false,
      },
   },

   ["nvim-telescope/telescope.nvim"] = function ()
      local actions = require "telescope.actions"

      return {
         extensions_list = {
            "persisted",
            "ui-select",
            "frecency",
         },
         defaults = {
            cache_picker = {
               num_pickers = 64,
            },
            mappings = {
               i = {
                  ["<C-q>"] = actions.close,
               },
               n = {
                  ["<C-q>"] = actions.close,
               },
            },
         },
      }
   end,

   ["NvChad/ui"] = {
      statusline = {
         overriden_modules = function ()
            return require "custom.ui.statusline.modules"
         end
      },
   },
}
