(vim.cmd "packadd packer.nvim")

(var {: load-configs} (require :plugins.lib.packer))
(var {:run_new packer-run} (require :core.packer))

(var plugins
  (load-configs [
    ;; basic
    [:packer    {:as :packer.nvim}]
    [:tangerine {:as :tangerine.nvim}]
    :plenary

    ;; editing
    :Comment
    :editorconfig
    :formatter
    :friendly-snippets
    :hop
    :nvim-autopairs
    :nvim-surround

    ;; treesitter
    :indent-blankline
    :nvim-treesitter

    ;; lsp
    :cmp
    :fidget
    :nvim-lsp-installer
    :nvim-lspconfig
    :trouble

    ;; git
    :diffview
    :gitsigns

    ;; ui
    :lualine
    :nightfox
    :nvim-scrollbar
    :nvim-tree
    :nvim-web-devicons
    :tabby
    :telescope
    :telescope-frecency
    :telescope-ui-select
    :which-key

    ;; other
    :haskell-vim
    :neorg
    :persisted
  ]))

(packer-run plugins)
