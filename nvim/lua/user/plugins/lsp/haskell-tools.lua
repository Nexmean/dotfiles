return {
  "MrcJkb/haskell-tools.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  ft = "haskell",
  config = function()
    local ht = require "haskell-tools"
    local hls_group = vim.api.nvim_create_augroup("hls", { clear = false })
    ht.setup {
      hls = {
        -- See nvim-lspconfig's  suggested configuration for keymaps, etc.
        on_attach = function(client, bufnr)
          Config.lsp.common_on_attach(client, bufnr)
          require("caskey.utils").emit(hls_group, bufnr)
        end,
        settings = {
          haskell = {
            checkProject = false,
          },
        },
      },
      tools = {
        hover = {
          border = {
            { "┌", "FloatBorder" },
            { "─", "FloatBorder" },
            { "┐", "FloatBorder" },
            { "│", "FloatBorder" },
            { "┘", "FloatBorder" },
            { "─", "FloatBorder" },
            { "└", "FloatBorder" },
            { "│", "FloatBorder" },
          },
          stylize_markdown = true,
        },
      },
    }
  end,
}
