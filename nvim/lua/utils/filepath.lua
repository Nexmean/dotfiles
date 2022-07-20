local fn = vim.fn

local M = {}

function M.split(fp)
   local res = {}
   for w in (fp .. "/"):gmatch("([^/]*)/") do
       res[#res+1] = w
   end
   return res
end

function M.split_dir(fp)
   local dir, filename = string.match(fp, "(.*/)([^/]+)")
   return dir, filename
end

function M.short(fp)
   local res
   if string.sub(fp, 1, 1) == "/" then
      res = "/"
   else
      res = ""
   end

   local fp_chunks = M.split(fp)
   for i, chunk in ipairs(fp_chunks) do
      if chunk ~= "" then
         if i ~= #fp_chunks then
            local short_chunk
            if string.sub(chunk, 1, 1) == "." then
               short_chunk = string.sub(chunk, 1, 2)
            else
               short_chunk = string.sub(chunk, 1, 1)
            end
            res = res .. short_chunk .. "/"
         else
            res = res .. chunk
         end
      end
   end
   return res
end

function M.relative(filepath)
   local cwd = fn.getcwd() .. "/"
   local home = vim.env.HOME .. "/"

   if string.sub(filepath, 1, #cwd) == cwd then
      return string.sub(filepath, #cwd + 1, #filepath)
   elseif string.sub(filepath, 1, #home) == home then
      return "~/" .. string.sub(filepath, #home + 1, #filepath)
   else
      return filepath
   end
end

return M
