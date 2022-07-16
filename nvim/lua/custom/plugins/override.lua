return {
   ["kyazdani42/nvim-tree.lua"] = {
      git = {
         enable = true
      },
   },
   ["nvim-telescope/telescope.nvim"] = {
      extensions = {
         file_browser = {},
         persisted = {},
         ["ui-select"] = {},
      },
      extensions_list = {
         "file_browser",
         "persisted",
         "ui-select",
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
