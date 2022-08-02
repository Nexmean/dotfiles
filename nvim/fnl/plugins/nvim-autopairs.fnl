{
  :from   :windwp/nvim-autopairs
  :after  :nvim-cmp
  :config #(let
    [autopairs (require :nvim-autopairs)
     cmp       (require :cmp)]

    (autopairs.setup {
      :fast_wrap        {}
      :disable_filetype [:TelescopePrompt :vim]
    })

    (let
      [cmp-autopairs (require :nvim-autopairs.completion.cmp)]
      (cmp.event:on :confirm_done (cmp-autopairs.on_confirm_done))
    )
  )
}
