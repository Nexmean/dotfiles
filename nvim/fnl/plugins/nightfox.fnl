{
  :from :EdenEast/nightfox.nvim
  :config #(let
    [nightfox  (require :nightfox)
     ui-colors (require :ui.colors)]

    (nightfox.setup {
      :groups {
        :all {
          :NvimTreeNormal  {:fg :fg1  :bg :bg1}
          :TelescopeNormal {:bg :bg0}
          :TelescopeBorder {:bg :bg0  :fg :bg0}
        }
      }
    })
    (vim.cmd "colorscheme duskfox")
    (ui-colors.generate_user_config_highlights)
  )
}
