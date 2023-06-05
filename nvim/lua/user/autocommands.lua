local autocmd = vim.api.nvim_create_autocmd

autocmd({ "BufRead" }, {
  pattern = "justfile",
  callback = function(e)
    vim.api.nvim_buf_set_option(e.buf, "filetype", "make")
  end,
})

autocmd({ "BufWinEnter" }, {
  pattern = "scala",
  callback = function(e)
    vim.api.nvim_win_set_option(e.win, "foldmethod", "indent")
  end,
})
