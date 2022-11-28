return function ()
  require("formatter").setup {
    logging = true,
    log_level = vim.log.levels.WARN,
    filetype = {
      haskell = {
        function()
           return {
              exe = "stylish-haskell",
              stdin = true,
           }
        end,
      },
      cabal = {
        function()
          return {
            exe = "cabal-fmt",
            args = {"--no-tabular"},
            stdin = true,
          }
        end
      },
      lua = {
        require("formatter.filetypes.lua").stylua,
      },
    },
  }
end
