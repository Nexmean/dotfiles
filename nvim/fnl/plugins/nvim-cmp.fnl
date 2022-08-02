(var {: call} (require :core.lib))

{
  :from  :hrsh7th/nvim-cmp
  :after :friendly-snippets
  :config #(let
    [
      cmp        (require :cmp)
      cmp-window (require :cmp.utils.window)
      luasnip    (require :luasnip)
      ui-icons   (require :ui.icons)
      border     #[
        ["┌" $1]
        ["─" $1]
        ["┐" $1]
        ["│" $1]
        ["┘" $1]
        ["─" $1]
        ["└" $1]
        ["│" $1]
      ]
    ]

    (set cmp-window.info_ cmp-window.info)
    (set cmp-window.info (fn [self]
      (var info (self:info))
      (set info.scrollable false)
      info
    ))

    (cmp.setup {
      :window {
        :completion {
          :border       (border "CmpBorder")
          :winhighlight "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None"
        }
        :documentation {
          :border       (border "CmpDocBorder")
          :winhighlight "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None"
        }
      }
      :snippet {
        :expand #(luasnip.lsp_expand $1.body) 
      }
      :formatting {
        :format (fn [_ vim-item]
          (var icons ui-icons.lspkind)
          (set vim-item.kind (string.format "%s %s" (. icons vim-item.kind) vim-item.kind))
          vim-item
        )
      }
      :mapping {
        :<C-p>     (cmp.mapping.select_prev_item)
        :<C-n>     (cmp.mapping.select_next_item)
        :<C-d>     (cmp.mapping.scroll_docs -4)
        :<C-f>     (cmp.mapping.scroll_docs 4)
        :<C-Space> (cmp.mapping.complete)
        :<C-e>     (cmp.mapping.close)
        :<CR>      (cmp.mapping.confirm {
          :behavior cmp.ConfirmBehavior.Replace
          :select   false
        })
        :<Tab> (cmp.mapping
          (fn [fallback]
            (if
              (cmp.visible)
                (cmp.select_next_item)
              (luasnip.expand_or_jumpable)
                (vim.fn.feedkeys (vim.api.nvim_replace_termcodes :<Plug>luasnip-expand-or-jump true true true) "")
                
                (fallback)
            )
          )
          [:i :s]
        )
        :<S-Tab> (cmp.mapping
          (fn [fallback]
            (if
              (cmp.visible)
                (cmp.select_prev_item)
              (luasnip.jumpable -1)
                (vim.fn.feedkeys (vim.api.nvim_replace_termcodes :<Plug>luasnip-jump-prev true true true) "")
              ;else 
                (fallback)
            )
          )
          [:i :s]
        )
      }
      :sources [ 
        {:name :luasnip}
        {:name :nvim_lsp}
        {:name :buffer}
        {:name :nvim_lua}
        {:name :path}
      ]
    })
  )
}
