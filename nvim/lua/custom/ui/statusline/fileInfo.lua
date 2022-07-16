local utils = require "custom.utils"

local fn = vim.fn
local sep_style = vim.g.statusline_sep_style
local separators = (type(sep_style) == "table" and sep_style) or require("nvchad_ui.icons").statusline_separators[sep_style]
local sep_r = separators["right"]

return function()
   local icon = "  "

   local filename = (fn.expand "%" == "" and "Empty ") or fn.expand "%:t"

   if filename ~= "Empty " then
      local devicons_present, devicons = pcall(require, "nvim-web-devicons")

      if devicons_present then
         local ft_icon = devicons.get_icon(filename)
         icon = (ft_icon ~= nil and " " .. ft_icon) or ""
      end

      local filepath = (fn.expand "%" == "" and "Empty ") or fn.expand "%"
      local rel_filepath = utils.filepath.relative_filepath(filepath)

      if vim.o.columns > 300 and #rel_filepath < 120 then
         filename = rel_filepath
      elseif vim.o.columns > 200 and #rel_filepath < 80 then
         filename = rel_filepath
      elseif vim.o.columns > 140 and #rel_filepath < 50 then
         filename = rel_filepath
      elseif vim.o.columns > 100 and #rel_filepath < 30 then
         filename = rel_filepath
      else
         filename = utils.filepath.short(rel_filepath)
      end

      filename = " " .. filename .. " "
   end

   return "%#St_file_info#" .. icon .. filename .. "%#St_file_sep#" .. sep_r
end
