(var {: call} (require :core.lib))

{
  :from   :nvim-treesitter/nvim-treesitter
  :module :nvim-treesitter
  :setup  #((. (require :core.lazy_load) :on_file_open) :nvim-treesitter)
  :cmd    [
    :TSInstall
    :TSBufEnable
    :TSBufDisable
    :TSEnable
    :TSDisable
    :TSModuleInfo
  ]
  :run    :TSUpdate
  :config #(let
    [treesitter     (require :nvim-treesitter.configs)
     parser-configs ((. (require :nvim-treesitter.parsers) :get_parser_configs))]

    (tset parser-configs :haskell {
      :install_info {
        :url   "~/.dotfiles/deps/tree-sitter-haskell"
        :files [:src/parser.c :src/scanner.c]
      }
    })

    (treesitter.setup {
      :ensure_installed [
        :c :cpp
        :bash
        :haskell
        :javascript :typescript
        :json :toml :yaml
        :lua :fennel
        :make
        :markdown
        :nix
        :norg
        :proto
        :python
        :rust
        :sql
      ]
      :highlight {
        :enable           true
        :use_languagetree true
      }
      :rainbow {
        :enable true
      }
    })

    (set vim.opt.foldmethod :expr)
    (set vim.opt.foldexpr   "nvim_treesitter#foldexpr()")

    (vim.api.nvim_create_autocmd [:BufReadPost :FileReadPost] {
      :pattern :*
      :command "normal zR"
    })
  )
}
