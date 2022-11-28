return function()
  local ht = require "haskell-tools"
  local lsp = require "user.lsp"
  local def_opts = { noremap = true, silent = true, }
  ht.setup {
    hls = {
      -- See nvim-lspconfig's  suggested configuration for keymaps, etc.
      on_attach = function(client, bufnr)
        lsp.common_on_attach(client, bufnr)
        local opts = vim.tbl_extend('keep', def_opts, {buffer = bufnr, desc = "hoogle signature"})
        -- haskell-language-server relies heavily on codeLenses,
        -- so auto-refresh (see advanced configuration) is enabled by default
        -- vim.keymap.set('n', '<leader>ca', vim.lsp.codelens.run, opts)
        vim.keymap.set('n', '<leader>sh', ht.hoogle.hoogle_signature, opts)
        -- default_on_attach(client, bufnr)  -- if defined, see nvim-lspconfig
      end,
      settings = {
        haskell = {
          checkProject = false,
        },
      },
    },
    hover = {
      border = {
        { '┌', 'FloatBorder' },
        { '─', 'FloatBorder' },
        { '┐', 'FloatBorder' },
        { '│', 'FloatBorder' },
        { '┘', 'FloatBorder' },
        { '─', 'FloatBorder' },
        { '└', 'FloatBorder' },
        { '│', 'FloatBorder' },
      },
    },
  }
end
