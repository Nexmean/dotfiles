-- :fennel:1659219086
local function _1_()
  local lspconfig = require("lspconfig")
  local utils = require("core.utils")
  local default_servers = {"jsonls", "hls", "bashls", "dockerls", "marksman", "yamlls"}
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local on_attach
  local function _2_(client, bufnr)
    local vim_version = vim.version()
    local lsp_mappings = utils.load_config().mappings.lspconfig
    if (vim_version > 7) then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    else
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
    end
    return utils.load_mappings({lsp_mappings}, {buffer = bufnr})
  end
  on_attach = _2_
  require("ui.lsp")
  capabilities.textDocument.completion.completionItem = {documentationFormat = {"markdown", "plaintext"}, snippetSupport = true, preselectSupport = true, insertReplaceSupport = true, labelDetailsSupport = true, deprecatedSupport = true, commitCharactersSupport = true, tagSupport = {valueSet = {1}}, resolveSupport = {properties = {"documentation", "detail", "additionalTextEdits"}}}
  lspconfig.sumneko_lua.setup({on_attach = on_attach, capabilities = capabilities, settings = {Lua = {diagnostics = {globals = {"vim"}}, workspace = {library = {[vim.fn.expand("$VIMRUNTIME/lua")] = true, [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true}, maxPreload = 100000, preloadFileSize = 10000}}}})
  for _, lsp in ipairs(default_servers) do
    lspconfig[lsp].setup({on_attach = on_attach, capabilities = capabilities})
  end
  return nil
end
return {from = "neovim/nvim-lspconfig", after = "nvim-lsp-installer", module = "lspconfig", config = _1_}