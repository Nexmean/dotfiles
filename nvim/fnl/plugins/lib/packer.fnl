(fn concat [...]
  (var result []) 
  (each [_ list (ipairs ...)]
    (each [_ e (ipairs list)]
      (table.insert result e)))
  result
)

(fn load-base-config [name]
  (var (present? config) (pcall require (.. :plugins. name)))
  (when (not present?)
    (error (.. "load-base-configs: \"" name "\" config isn't present")))
  (if (vim.tbl_islist config)
    (icollect [_ [name config#] (ipairs config)] (vim.tbl_extend :keep {:as name} config#))
    [(vim.tbl_extend :keep {:as name} config)]
  )
)

(fn load-config [raw-plugin]
  (var [name overrides-raw]
    (match raw-plugin
      [name overrides] [name overrides]
      [name]           [name {}]
      name             [name {}]))
  (var base-config (load-base-config name))
  (var overrides
    (if (vim.tbl_islist overrides-raw)
      overrides-raw
      (do
        (var plugin-names (icollect [_ p (ipairs base-config)] p.as))
        (icollect [_ pn (ipairs plugin-names)] [pn overrides-raw])
      )))
  (var overrides-table
    (collect [_ [name override] (ipairs overrides)]
      name override))
  (icollect [_ plugin (ipairs base-config)]
    (do
      (var new-plugin
        (vim.tbl_deep_extend :keep (or (. overrides-table plugin.as) {}) plugin))
      new-plugin))
)

(fn load-configs [raw-plugins]
  (var all-plugins
    (concat
      (icollect [_ raw-plugin (ipairs raw-plugins)]
        (load-config raw-plugin))))
  (each [_ plugin (ipairs all-plugins)] (do
    (tset plugin 1 plugin.from)
    (set plugin.from nil)))
  all-plugins
)

{
  : load-configs
}
