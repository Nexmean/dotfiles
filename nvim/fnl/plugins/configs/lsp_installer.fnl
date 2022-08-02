(var (present? lsp-installer) (pcall require :nvim-lsp-installer))

(when present?
   (lsp-installer.setup
      {:automatic_installation {:exclude [:hls]}
       :ui
         {:icons
            {:server_installed   " "
             :server_pending     " "
             :server_uninstalled "ﮊ "}
          :keymaps
            {:toggle_server_expand   "<CR>"
             :install_server         :i
             :update_server          :u
             :check_server_version   :c
             :update_all_servers     :U
             :check_outdated_servers :C
             :uninstall_server       :X }}
       :max_concurrent_installer 10 }))
