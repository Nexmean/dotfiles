(var {: call} (require :core.lib))

{
  :from   :williamboman/nvim-lsp-installer
  :opt    true
  :cmd    (. (require :core.lazy_load) :lsp_cmds)
  :setup  #((. (require :core.lazy_load) :on_file_open) :nvim-lsp-installer)
  :config #(let
    [lsp-installer (require :nvim-lsp-installer)]
    (lsp-installer.setup {
      :automatic_installation {:exclude [:hls]}
      :ui {
        :icons {
          :server_installed   " "
          :server_pending     " "
          :server_uninstalled "ﮊ "
        }
        :keymaps {
          :toggle_server_expand   "<CR>"
          :install_server         :i
          :update_server          :u
          :check_server_version   :c
          :update_all_servers     :U
          :check_outdated_servers :C
          :uninstall_server       :X 
        }
      }
      :max_concurrent_installer 10
    })
  )
}
