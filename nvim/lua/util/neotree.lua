local M = {}

function M.fix()
  local wins = vim.api.nvim_list_wins()

  local neotree_win
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local win_ft = vim.api.nvim_buf_get_option(buf, "filetype")
    if win_ft == "neo-tree" then
      neotree_win = win
      break
    end
  end

  if neotree_win ~= nil then
    vim.api.nvim_win_call(neotree_win, function()
      local width_before = vim.api.nvim_win_get_width(0)
      vim.cmd("wincmd H")
      vim.cmd("vertical resize " .. width_before)
      vim.cmd("wincmd =")
    end)
  end
end

return M
