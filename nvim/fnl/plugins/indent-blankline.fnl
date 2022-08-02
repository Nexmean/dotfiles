(var {: call} (require :core.lib))

{
  :from   :lukas-reineke/indent-blankline.nvim
  :opt    true
  :setup  #((. (require :core.lazy_load) :on_file_open) :indent-blankline)
  :config #(let
    [blankline (require :indent_blankline)]
    (blankline.setup {
      :filetype_exclude [
        :help
        :terminal
        :alpha
        :packer
        :lspinfo
        :TelescopePrompt
        :TelescopeResults
        :lsp-installer
        ""
      ]
      :buftype_exclude                [:terminal]
      :indentLine_enabled             1
      :show_current_context           true
      :show_current_context_start     true
      :show_first_indent_level        false
      :show_trailing_blankline_indent false
    })
  )
}
