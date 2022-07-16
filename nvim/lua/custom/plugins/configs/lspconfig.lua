local util = require "lspconfig.util"

local M = {}

M.setup_lsp = function (attach, capabilities)
   local lspconfig = require("lspconfig")

   lspconfig["hls"].setup {
      on_attach = function (client, bufnr)
         attach(client, bufnr)
      end,
      capabilities = capabilities,
      root_dir = function (startpath)
         local project_patterns = { "hie.yaml", "cabal.project", "stack.yaml" }
         local cwd = vim.fn.getcwd()

         for _, pattern in ipairs(project_patterns) do
            for _, p in ipairs(vim.fn.glob(util.path.join(cwd, pattern), true, true)) do
               if util.path.exists(p) then
                  return cwd
               end
            end
         end

         local all_patterns = vim.tbl_flatten({ project_patterns, { "*.cabal", "package.yaml" } })
         return util.root_pattern(table.unpack(all_patterns))(startpath)
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
