local utils = require "utils"

local fn = vim.fn
local sep_style = vim.g.statusline_sep_style
local separators = (type(sep_style) == "table" and sep_style) or require("nvchad_ui.icons").statusline_separators[sep_style]
local sep_r = separators["right"]

return function()
   local icon = "  "

   local dir = ""
   local filename = (fn.expand "%" == "" and "Empty ") or fn.expand "%:t"

   if filename ~= "Empty " then
      local devicons_present, devicons = pcall(require, "nvim-web-devicons")

      if devicons_present then
         local ft_icon = devicons.get_icon(filename)
         icon = (ft_icon ~= nil and ft_icon .. " ") or ""
      end

      local filepath = fn.expand "%"

      if string.sub(filepath, 1, 5) == "term:" then
         filename = fn.expand "%:t"
      elseif string.find(filepath, "/") ~= nil then
         local rel_filepath = utils.filepath.relative(filepath)

         local fp_fit = (#rel_filepath / (vim.o.columns - 30)) < 0.3

         if fp_fit then
            dir, filename = utils.filepath.split_dir(rel_filepath)
         else
            dir, filename = utils.filepath.split_dir(utils.filepath.short(rel_filepath))
         end
      else
         filename = filepath
      end
   end

   return (
      "%#St_file_info#" .. icon
      .. "%#St_file_info_dir#" .. dir .. "%#St_file_info#" .. filename
      .. " " .. "%#St_file_sep#" .. sep_r
   )
end
