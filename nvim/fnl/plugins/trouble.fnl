{
  :from   :folke/trouble.nvim
  :after  :nvim-web-devicons
  :cmd    [:Trouble :TroubleToggle]
  :config #(let
    [trouble (require :trouble)]

    (trouble.setup {
      :action_keys {:cancel "<C-[>"}
    })
  )
}
