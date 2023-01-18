return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v2.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "s1n7ax/nvim-window-picker",
  },
  cmd = "Neotree",
  config = function()
    local utils = require "user.common.utils"

    vim.g.neo_tree_remove_legacy_commands = 1
    require("neo-tree").setup {
      filesystem = {
        follow_current_file = true,
      },
      default_component_configs = {
        modified = {
          symbol = "",
          highlight = "NeoTreeDimText",
        },
        git_status = {
          symbols = {
            -- Change type
            added = "",
            deleted = "",
            modified = "",
            renamed = "",
            -- Status type
            untracked = "",
            ignored = " N",
            unstaged = " U",
            staged = " S",
            conflict = " C",
          },
        },
        diagnostics = {
          symbols = {
            hint = " H",
            info = " I",
            warn = " W",
            error = " E",
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
  end,
}
