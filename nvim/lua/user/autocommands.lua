local autocmd = vim.api.nvim_create_autocmd

autocmd({ "WinEnter" }, {
  callback = function()
    if vim.o.bt == "" then
      vim.o.wrap = true
      vim.o.linebreak = true
    end
  end,
})

autocmd({ "WinLeave" }, {
  callback = function()
    if vim.o.bt == "" and vim.o.ft ~= "markdown" then
      vim.o.wrap = false
      vim.o.linebreak = false
    end
  end,
})

autocmd({ "BufRead" }, {
  pattern = "justfile",
  callback = function(e)
    vim.api.nvim_buf_set_option(e.buf, "filetype", "make")
  end,
})
