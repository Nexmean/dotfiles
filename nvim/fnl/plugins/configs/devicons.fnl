{
  :setup #(let
    [(present? devicons) (pcall require :nvim-web-devicons)]
    (when present?
       (devicons.setup {:override (require :ui.icons)}))
  )
}
