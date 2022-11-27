local autocmd = vim.api.nvim_create_autocmd

vim.g.markdown_fenced_languages = {"haskell", "lua", "bash"}

-- for reloading files
vim.o.autoread = true
autocmd({"BufEnter", "CursorHold", "CursorHoldI", "FocusGained"}, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = {"*"},
})

autocmd("FileType", {
  pattern = {"NeogitStatus", "NeogitCommontView"},
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

autocmd("BufWritePost", {
  pattern = {"*.hs", "*.cabal"},
  command = "FormatWrite"
})

autocmd("TermOpen", {
  pattern = "*",
  command = "setlocal nonumber norelativenumber",
})
