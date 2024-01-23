return {
  {
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
      vim.g.neo_tree_remove_legacy_commands = 1
      require("neo-tree").setup({
        sources = {
          "filesystem",
          "buffers",
          "git_status",
          "document_symbols",
        },
        filesystem = {
          follow_current_file = true,
          group_empty_dirs = false,
          use_libuv_file_watcher = true,
        },
        git_status = {
          follow_current_file = true,
          group_empty_dirs = false,
          window = {
            mappings = {
              ["o"] = function(state)
                local fs_commands = require("neo-tree.sources.filesystem.commands")
                fs_commands.open(state)
                vim.cmd("Gitsigns diffthis")
              end,
            },
          },
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
        document_symbols = {
          follow_cursor = true,
          kinds = {
            File = { icon = "󰈙", hl = "Tag" },
            Namespace = { icon = "󰌗", hl = "Include" },
            Package = { icon = "󰏖", hl = "Label" },
            Class = { icon = "󰌗", hl = "Include" },
            Property = { icon = "󰆧", hl = "@property" },
            Enum = { icon = "󰒻", hl = "@number" },
            Function = { icon = "󰊕", hl = "Function" },
            String = { icon = "󰀬", hl = "String" },
            Number = { icon = "󰎠", hl = "Number" },
            Array = { icon = "󰅪", hl = "Type" },
            Object = { icon = "󰅩", hl = "Type" },
            Key = { icon = "󰌋", hl = "" },
            Struct = { icon = "󰌗", hl = "Type" },
            Operator = { icon = "󰆕", hl = "Operator" },
            TypeParameter = { icon = "󰊄", hl = "Type" },
            StaticMethod = { icon = "󰠄 ", hl = "Function" },
          },
        },
        source_selector = {
          winbar = true,
          sources = {
            { source = "filesystem", display_name = " 󰉓  " },
            { source = "buffers", display_name = "   " },
            { source = "git_status", display_name = "  " },
            { source = "document_symbols", display_name = " 󰊕 " },
          },
          content_layout = "center",
        },
        window = {
          position = "left",
          width = 45,
          mappings = {
            ["<tab>"] = {
              "toggle_node",
              nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
            },
            ["o"] = "open_with_window_picker",
          },
        },
      })

      local neotree_group = vim.api.nvim_create_augroup("neo-tree-user", {})

      vim.api.nvim_create_autocmd("WinResized", {
        group = neotree_group,
        callback = function(e)
          if vim.api.nvim_buf_get_option(e.buf, "filetype") == "neo-tree" then
            vim.cmd("wincmd =")
          end
        end,
      })
    end,
  },
}
