local horizontal_size = function(term)
  if term.direction == "horizontal" then
    return vim.o.lines * 0.45
  elseif term.direction == "vertical" then
    return vim.o.columns * 0.4
  end
end

local horizontal_on_open = function()
  local wins = vim.api.nvim_list_wins()

  local neotree_win, overseer_win
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local win_ft = vim.api.nvim_buf_get_option(buf, "filetype")
    if win_ft == "neo-tree" then
      neotree_win = win
    elseif win_ft == "OverseerList" then
      overseer_win = win
      vim.notify("Found OverseerList", vim.log.levels.INFO)
    end

    if neotree_win ~= nil and overseer_win ~= nil then
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

  if overseer_win ~= nil then
    vim.cmd("OverseerClose")
  end
end

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    size = horizontal_size,
    shade_terminals = false,
    on_open = horizontal_on_open,
  },

  config = function(_, opts)
    require("toggleterm").setup(opts)

    local Terminal = require("toggleterm.terminal").Terminal
    local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

    vim.api.nvim_create_user_command("LazyGitToggle", function()
      lazygit:toggle()
    end, {})

    local mprocs = Terminal:new({
      cmd = "mprocs",
      hidden = true,
      direction = "horizontal",
      size = horizontal_size,
      on_open = horizontal_on_open,
    })

    vim.api.nvim_create_user_command("MprocsToggle", function()
      mprocs:toggle()
    end, {})
  end,
}
