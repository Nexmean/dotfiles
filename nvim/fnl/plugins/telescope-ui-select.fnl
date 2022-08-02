(var {: call} (require :core.lib))

{
  :from   :nvim-telescope/telescope-ui-select.nvim
  :after  :telescope
  :fn     :vim.lsp.buf.code_action
  :config #((. (require :telescope) :load_extension) :ui-select)
}
