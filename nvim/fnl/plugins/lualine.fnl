{
  :from   :nvim-lualine/lualine.nvim
  :after  :nightfox
  :config #(let
    [lualine (require :lualine)]
    (lualine.setup {
      :options {
        :section_separators   {:left :  :right :█}
        :component_separators {:left :  :right ""}
      }
      :sections {
        :lualine_y [:location]
        :lualine_z [] 
      }
    })
  )
}
