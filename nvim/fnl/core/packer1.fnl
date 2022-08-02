(var M {})

(fn M.bootstrap []
  (let
    [install-path (.. (vim.fn.stdpath :data) :/site/pack/packer/start/packer.nvim)]

    (vim.api.nvim_set_hl 0 :NormalFloat {:br :#1e222a})
    (when (> (vim.fn.empty (vim.fn.glob install-path)) 0)
      (print "Closing packer ..")
      (vim.fn.system [:git :clone :--depth :1 :https://github.com/wbthomason/packer.nvim install-path])

      ;; install plugins + compile their configs 
      (vim.cmd "packadd packer.nvim")
      (require :plugins)
      (vim.cmd :PackerSync)
    )
  )
)
