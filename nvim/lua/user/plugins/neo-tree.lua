return function()
  local utils = require "user.common.utils"

  vim.g.neo_tree_remove_legacy_commands = 1
  require("neo-tree").setup {
    default_component_configs = {
      modified = {
        symbol = "",
        highlight = "NeoTreeDimText",
      },
      git_status = {
        symbols = {
          -- Change type
          added = "",
          deleted = "",
          modified = "",
          renamed = "",
          -- Status type
          untracked = "",
          ignored = "",
          unstaged = "",
          staged = "",
          conflict = "",
        },
      },
    },
    source_selector = {
      winbar = false,
    },
    window = {
      width = 35,
      mappings = {
        ["<tab>"] = {
          "toggle_node",
          nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
        },
        ["o"] = "open_with_window_picker",
        ["f"] = utils.cmdfn [[Neotree focus filesystem left]],
        ["b"] = utils.cmdfn [[Neotree focus buffers left]],
        ["t"] = utils.cmdfn [[Neotree focus git_status left]],
      },
      filesystem = {
        use_libuv_file_watcher = true,
      },
    },
  }
end
