return {
  "mhartington/formatter.nvim",
  cmd = { "Format", "FormatLock", "FormatWrite", "FormatWriteLock" },
  config = function()
    require("formatter").setup {
      logging = true,
      log_level = vim.log.levels.WARN,
      filetype = {
        cabal = {
          function()
            return {
              exe = "cabal-fmt",
              args = { "--no-tabular" },
              stdin = true,
            }
          end,
        },
        lua = {
          require("formatter.filetypes.lua").stylua,
        },
        json = {
          require("formatter.filetypes.json").fixjson,
        },
      },
    }
  end,
}
