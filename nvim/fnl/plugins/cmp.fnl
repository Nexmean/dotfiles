[
  [:nvim-cmp (require :plugins.nvim-cmp)]
  [:LuaSnip  (require :plugins.LuaSnip)]

  [:cmp_luasnip {
    :from  :saadparwaiz1/cmp_luasnip
    :after :LuaSnip
  }]

  [:cmp-nvim-lua {
    :from  :hrsh7th/cmp-nvim-lua
    :after :cmp_luasnip
  }]

  [:cmp-nvim-lsp {
    :from  :hrsh7th/cmp-nvim-lsp
    :after :cmp-nvim-lua
  }]

  [:cmp-buffer {
    :from  :hrsh7th/cmp-buffer
    :after :cmp-nvim-lsp
  }]

  [:cmp-path {
    :from  :hrsh7th/cmp-path
    :after :cmp-buffer
  }]
]
