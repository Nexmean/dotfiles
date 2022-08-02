(require :core)
(require :core.options)

(vim.defer_fn
   (let [core_utils (require :core.utils)]
      (fn [] (core_utils.load_mappings)))
   0)

(let [core_packer (require :core.packer)]
   (core_packer.bootstrap))
(require :plugins-new)
