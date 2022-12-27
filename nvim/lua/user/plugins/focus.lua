return function ()
  require("focus").setup {
    width = 120,
    signcolumn = false,
    compatible_filetrees = {"neo-tree"},
  }
  vim.cmd[[FocusEnable]]
end
