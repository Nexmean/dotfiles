local autocmd = vim.api.nvim_create_autocmd
local keybind_opts = { noremap = false, silent = true, nowait = true }

-- autocmd({"BufEnter", "BufWinEnter"}, {
--   pattern = "*",
--   callback = function ()
--     if vim.o.buftype == 'quickfix' then
--       vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close<CR>", keybind_opts)
--     end
--   end
-- })

autocmd({ "WinEnter" }, {
  callback = function ()
    if vim.o.bt == "" then
      vim.o.wrap = true
      vim.o.linebreak = true
    end
  end
})

autocmd({ "WinLeave" }, {
  callback = function ()
    if vim.o.bt == "" and vim.o.ft ~= "markdown" then
      vim.o.wrap = false
      vim.o.linebreak = false
    end
  end
})
