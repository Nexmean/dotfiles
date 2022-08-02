{
  :from   :nvim-neorg/neorg
  :ft     :norg
  :after  :nvim-treesitter
  :config #(let
    [neorg (require :neorg)]
    (neorg.setup {
      :load {
        :core.defaults    {}
        :core.norg.dirman {
          :workspaces {
            :work "~/Notes/work"
            :home "~/Notes/home"
          }
        }
      }
    })
  )
}
