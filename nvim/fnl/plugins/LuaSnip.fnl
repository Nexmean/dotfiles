{
  :from   :L3MON4D3/LuaSnip
  :wants  :friendly-snippets
  :after  :nvim-cmp
  :config #(let
    [luasnip                     (require :luasnip)
     luasnip-loaders-from-vscode (require :luasnip.loaders.from_vscode)]

    (luasnip.config.set_config {
      :history      true
      :updateevents "TextChanged,TextChangedI"
    })

    (luasnip-loaders-from-vscode.lazy_load)
    (luasnip-loaders-from-vscode.lazy_load {:paths (or vim.g.luasnippets_path "")})

    (vim.api.nvim_create_autocmd :InsertLeave {
      :callback
        #(when (and (. luasnip.session.current_nodes (vim.api.nvim_get_current_buf))
                    (not luasnip.session.jump_active))
          (luasnip.unlink_current)
        )
    })
  )
}

