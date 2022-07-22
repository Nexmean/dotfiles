local M = {}

function M.setup()
   local present, devicons = pcall(require, "nvim-web-devicons")
   local icons = require "ui.icons"

   if present then
      local options = { override = icons }

      devicons.setup(options)
   end
end

return M
