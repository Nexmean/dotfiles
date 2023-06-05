return {
  { "neovim/nvim-lspconfig" },

  "haskell-tools",

  "scala-metals",

  { "folke/neodev.nvim" },

  { "mfussenegger/nvim-jdtls" },

  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local nls = require "null-ls"
      local builtins = nls.builtins

      nls.setup {
        sources = {
          builtins.formatting.raco_fmt.with {
            filetypes = { "racket", "scheme" },
          },
        },
      }
    end,
  },

  -- UTILS
  {
    "ray-x/lsp_signature.nvim",
    opts = {
      hint_enable = false,
      hint_prefix = "● ",
      max_width = 80,
      max_height = 12,
      handler_opts = {
        border = "single",
      },
    },
  },

  {
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config { virtual_lines = false }
    end,
  },

  { "j-hui/fidget.nvim", enabled = false, config = true },
}
