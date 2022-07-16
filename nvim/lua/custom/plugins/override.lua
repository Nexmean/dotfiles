return {
   ["kyazdani42/nvim-tree.lua"] = {
      git = {
         enable = true
      },
   },
   ["nvim-telescope/telescope.nvim"] = {
      extensions_list = {
         "persisted",
         "ui-select",
         "frecency",
      },
   },
   ["NvChad/ui"] = {
      statusline = {
         overriden_modules = function ()
            return require "custom.ui.statusline.modules"
         end
      },
   },
}
