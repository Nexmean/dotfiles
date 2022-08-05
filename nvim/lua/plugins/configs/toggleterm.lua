local toggleterm = require "toggleterm"

local options = {
   open_mapping = "<C-`>",
   highlights = {
      NormalFloat = {
         link = "NormalFloat",
      },
      FloatBorder = {
         link = "ToggleTermFloatBorder",
      },
   },
   direction = "float",
   shade_terminals = false,
   start_in_insert = true,
   float_opts = {
      width = function()
         return math.floor(vim.o.columns * 0.8)
      end,
      height = function()
         return math.floor(vim.o.lines * 0.8)
      end,
   },
}

toggleterm.setup(options)
