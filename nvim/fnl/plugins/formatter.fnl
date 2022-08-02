{
  :from :mhartington/formatter.nvim
  :cmd  [:Format :FormatWrite]
  :config #(let
    [formatter (require :formatter)]
    (formatter.setup {
      :logging true
      :log_level vim.log.levels.WARN
      :filetype {
        :haskell [#{:exe :stylish-haskell  :stdin true}]
        :lua     [(. (require :formatter.filetypes.lua) :stylua)]
      }
    })
  )
}
