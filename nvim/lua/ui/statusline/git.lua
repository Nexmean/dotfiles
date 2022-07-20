return function()
   if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
      return ""
   end

   local git_status = vim.b.gitsigns_status_dict

   local added = (git_status.added and git_status.added ~= 0) and ("  " .. git_status.added) or ""
   local changed = (git_status.changed and git_status.changed ~= 0) and ("  " .. git_status.changed) or ""
   local removed = (git_status.removed and git_status.removed ~= 0) and ("  " .. git_status.removed) or ""
   local branch_name = " " .. git_status.head .. " "

   return "%#St_gitIcons#" .. branch_name .. added .. changed .. removed
end
