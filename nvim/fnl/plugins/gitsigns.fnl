(var {: call} (require :core.lib))

{
  :from   :lewis6991/gitsigns.nvim
  :ft     :gitcommit
  :setup  #((. (require :core.lazy_load) :gitsigns))
  :config #((. (require :gitsigns) :setup) {})
}
