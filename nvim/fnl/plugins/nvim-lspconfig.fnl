{
  :from   :neovim/nvim-lspconfig
  :after  :nvim-lsp-installer
  :module :lspconfig
  :config #(let
    [
      lspconfig       (require :lspconfig)
      utils           (require :core.utils)
      default-servers [:jsonls :hls :bashls :dockerls :marksman :yamlls]
      capabilities    (vim.lsp.protocol.make_client_capabilities)
      on_attach       (fn [client bufnr]
        (let
          [vim-version  (vim.version)
           lsp-mappings (-> (utils.load_config) (. :mappings :lspconfig))]

          (if (> vim-version 7)
            (do
              (set client.server_capabilities.documentFormattingProvider      false)
              (set client.server_capabilities.documentRangeFormattingProvider false))
            (do
              (set client.resolved_capabilities.document_formatting       false)
              (set client.resolved_capabilities.document_range_formatting false)))

          (utils.load_mappings [lsp-mappings] {:buffer bufnr})
        )
      )
    ]
    
    (require :ui.lsp)

    (set capabilities.textDocument.completion.completionItem {
      :documentationFormat     [:markdown :plaintext]
      :snippetSupport          true
      :preselectSupport        true
      :insertReplaceSupport    true
      :labelDetailsSupport     true
      :deprecatedSupport       true
      :commitCharactersSupport true
      :tagSupport              {:valueSet [1]}
      :resolveSupport {
        :properties [ 
          :documentation
          :detail
          :additionalTextEdits
        ]
      }
    })

    (lspconfig.sumneko_lua.setup {
      : on_attach
      : capabilities

      :settings {
        :Lua {
          :diagnostics {:globals [:vim]}
          :workspace {
            :library { 
              (vim.fn.expand :$VIMRUNTIME/lua)         true
              (vim.fn.expand :$VIMRUNTIME/lua/vim/lsp) true
            }
            :maxPreload      100000
            :preloadFileSize 10000
          }
        }
      }
    })

    (each [_ lsp (ipairs default-servers)]
      ((. lspconfig lsp :setup) {: on_attach : capabilities}))
  )
}
