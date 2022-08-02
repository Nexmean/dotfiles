-- :fennel:1659301706
local function _1_()
  local persisted = require("persisted")
  local function _2_()
    local bufname = vim.fn.bufname()
    local last_tab_3f = (1 == vim.fn.tabpagenr("$"))
    if ((bufname == "NeogitStatus") or (bufname == "NeogitCommitView")) then
      if last_tab_3f then
        pcall(vim.cmd, "tabnew")
      else
        pcall(vim.cmd, "tabclose")
      end
    else
    end
    pcall(vim.cmd, "bw NeogitStatus")
    return pcall(vim.cmd, "bw NeogitCommitView")
  end
  return persisted.setup({autoload = true, use_git_branch = true, before_save = _2_})
end
return {from = "olimorris/persisted.nvim", config = _1_}