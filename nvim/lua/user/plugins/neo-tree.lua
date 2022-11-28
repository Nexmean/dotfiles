return function ()
  vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
  require("neo-tree").setup {
    window = {
      mappings = {
        ["<tab>"] = {
          "toggle_node",
          nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use 
        },
        ["o"] = "open_with_window_picker",
      }
    },
  }
end
