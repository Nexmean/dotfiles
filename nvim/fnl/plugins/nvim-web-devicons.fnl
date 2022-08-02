{
  :from   :kyazdani42/nvim-web-devicons
  :module :nvim-web-devicons
  :config #(let
    [(present? devicons) (pcall require :nvim-web-devicons)]
    (when present?
      (devicons.setup {:override (require :ui.icons)}))
  )
}
