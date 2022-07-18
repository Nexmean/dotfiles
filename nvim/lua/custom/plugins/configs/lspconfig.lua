local M = {}

M.setup_lsp = function (attach, capabilities)
   local lspconfig = require("lspconfig")

   local default_servers = {"jsonls", "hls"}

   for _, lsp in ipairs(default_servers) do
      lspconfig[lsp].setup {
         on_attach = attach,
         capabilities = capabilities,
      }
   end
end

return M
