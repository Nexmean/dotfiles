local codelens = require "user.lsp.codelens"
local lsp = require "user.lsp"
local lspconfig = require "lspconfig"

-- Java
require "user.lsp.java"

-- Typescript
lspconfig.tsserver.setup(lsp.create_config())

-- Python
lspconfig.pyright.setup(lsp.create_config())

-- Lua
require "user.lsp.lua"

-- Teal
require "user.lsp.teal"

-- Bash
lspconfig.bashls.setup(lsp.create_config())

-- C#
lspconfig.omnisharp.setup(lsp.create_config {
  cmd = { "/usr/bin/omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
  filetypes = { "cs", "vb" },
  init_options = {},
  -- root_dir = lspconfig.util.root_pattern(".csproj", ".sln"),
  -- root_dir = vim.fn.getcwd
})

-- C, C++
lspconfig.clangd.setup(lsp.create_config())

-- Vim
lspconfig.vimls.setup(lsp.create_config())

-- Go
lspconfig.gopls.setup(lsp.create_config())

-- Scheme, Racket
lspconfig.racket_langserver.setup(lsp.create_config())

-- Dhall
lspconfig.dhall_lsp_server.setup(lsp.create_config())

-- markdown
lspconfig.marksman.setup(lsp.create_config())

require("lspconfig.ui.windows").default_options.border = "single"

vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    underline = true,
    signs = false,
    update_in_insert = true,
  })

-- DIAGNOSTICS: Only show the sign with the highest priority per line
-- From: `:h diagnostic-handlers-example`

local ns = vim.api.nvim_create_namespace "user_lsp"
local orig_signs_handler = vim.diagnostic.handlers.signs

-- Override the built-in signs handler
vim.diagnostic.handlers.signs = {
  show = function(_, bufnr, _, opts)
    -- Get all diagnostics from the whole buffer rather than just the
    -- diagnostics passed to the handler
    local diagnostics = vim.diagnostic.get(bufnr)

    -- Find the "worst" diagnostic per line
    local max_severity_per_line = {}
    for _, d in pairs(diagnostics) do
      local m = max_severity_per_line[d.lnum]
      if not m or d.severity < m.severity then
        max_severity_per_line[d.lnum] = d
      end
    end

    -- Pass the filtered diagnostics (with our custom namespace) to
    -- the original handler
    orig_signs_handler.show(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
  end,
  hide = function(_, bufnr)
    orig_signs_handler.hide(ns, bufnr)
  end,
}

local pop_opts = { border = "single", max_width = 80 }
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, pop_opts)
vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(vim.lsp.handlers.signature_help, pop_opts)
vim.lsp.codelens.display = codelens.display

lsp.define_diagnostic_signs {
  error = "",
  warn = "",
  hint = "",
  info = "",
}
