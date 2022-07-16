local fn = vim.fn
local sep_style = vim.g.statusline_sep_style
local separators = (type(sep_style) == "table" and sep_style) or require("nvchad_ui.icons").statusline_separators[sep_style]
local sep_r = separators["right"]

local function split_path(str)
   local res = {}
   for w in (str .. "/"):gmatch("([^/]*)/") do
       res[#res+1] = w
   end
   return res
end

local function drop_prefix(prefix, tbl)
   local res = {}
   local max = #tbl
   for i = 1, max do
      if prefix[i] ~= tbl[i] then
         res[#res+1] = tbl[i]
      end
   end
   return res
end

local function filepath_full(fpt)
   local res = ""
   for i, chunk in ipairs(fpt) do
      res = res .. chunk
      if i ~= #fpt then
         res = res .. "/"
      end
   end
   return res
end

local function filepath_short(fpt)
   local res = ""
   for i, chunk in ipairs(fpt) do
      if i ~= #fpt then
         res = res .. string.sub(chunk, 1, 1) .. "/"
      else
         res = res .. chunk
      end
   end
   return res
end

return function()
   local icon = "  "

   local filename = (fn.expand "%" == "" and "Empty ") or fn.expand "%:t"

   if filename ~= "Empty " then
      local devicons_present, devicons = pcall(require, "nvim-web-devicons")

      if devicons_present then
         local ft_icon = devicons.get_icon(filename)
         icon = (ft_icon ~= nil and " " .. ft_icon) or ""
      end

      local cwd = fn.getcwd()
      local filepath = (fn.expand "%" == "" and "Empty ") or fn.expand "%"
      local filepath_t_wo_cwd = drop_prefix(split_path(cwd), split_path(filepath))
      local full = filepath_full(filepath_t_wo_cwd)
      local short = filepath_short(filepath_t_wo_cwd)

      if vim.o.columns > 300 and #full < 120 then
         filename = full
      elseif vim.o.columns > 200 and #full < 80 then
         filename = full
      elseif vim.o.columns > 140 and #full < 50 then
         filename = full
      elseif vim.o.columns > 100 and #full < 30 then
         filename = full
      else
         filename = short
      end

      filename = " " .. filename .. " "
   end

   return "%#St_file_info#" .. icon .. filename .. "%#St_file_sep#" .. sep_r
end
