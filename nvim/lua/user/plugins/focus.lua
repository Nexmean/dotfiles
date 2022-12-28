return function ()
  require("focus").setup {
    signcolumn = false,
    excluded_filetypes = {"", "neo-tree"},
    excluded_buftypes = {"neo-tree", "nofile", "prompt", "popup", "terminal"},
    quickfixheight = 15,
    width = 100,
    minwidth = 30,
  }
  vim.cmd[[FocusEnable]]
end
