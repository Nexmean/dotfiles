local util = require "lspconfig.util"

local M = {}

M.setup_lsp = function (attach, capabilities)
   local lspconfig = require("lspconfig")

   lspconfig["hls"].setup {
      on_attach = function (client, bufnr)
         attach(client, bufnr)
      end,
      capabilities = capabilities,
      root_dir = function (filepath)
         return (util.root_pattern("hie.yaml", "cabal.project", "stack.yaml")(filepath)
            or util.root_pattern("*.cabal", "package.yaml")(filepath))
      end,
      settings = {
         haskell = {
            formattingProvider = "stylish-haskell"
         }
      }
   }

   local default_servers = {"jsonls"}

   for _, lsp in ipairs(default_servers) do
      lspconfig[lsp].setup {
         on_attach = attach,
         capabilities = capabilities,
      }
   end
end

return M
