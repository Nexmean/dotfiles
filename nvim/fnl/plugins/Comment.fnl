(var {: call} (require :core.lib))

{
  :from   :numToStr/Comment.nvim
  :keys   [:gc :gb]
  :config #((. (require :Comment) :setup) {})
}
