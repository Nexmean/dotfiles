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
    local lsp_config = Config.lsp.create_config()
    ht.setup {
      hls = {
        -- See nvim-lspconfig's  suggested configuration for keymaps, etc.
        on_attach = function(client, bufnr)
          lsp_config.on_attach(client, bufnr)
          require("caskey.utils").emit(hls_group, bufnr)
        end,
        capabilities = lsp_config.capabilities,
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
