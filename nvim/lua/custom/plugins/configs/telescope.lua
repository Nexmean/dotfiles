local actions = require "telescope.actions"
local lga_actions = require "telescope-live-grep-args.actions"

return {
  defaults = {
    cache_picker = {
      num_pickers = 16,
    },
    mappings = {
      i = {
        ["<c-v>"] = actions.select_vertical,
        ["<c-s>"] = actions.select_horizontal,
        ["<c-q>"] = actions.close,
        ["<m-q>"] = actions.send_to_qflist + actions.open_qflist
      },
      n = {
        ["<c-v>"] = actions.select_vertical,
        ["<c-s>"] = actions.select_horizontal,
        ["<c-q>"] = actions.close,
        ["<m-q>"] = actions.send_to_qflist + actions.open_qflist
      },
    }
  },

  pickers = {
    buffers = {
      mappings = {
        n = {
           ["<C-x>"] = actions.delete_buffer,
        },
        i = {
           ["<C-x>"] = actions.delete_buffer,
        },
      },
    },
  },

  extensions = {
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-l>g"] = lga_actions.quote_prompt { postfix = " --iglob " },
          ["<C-l>t"] = lga_actions.quote_prompt { postfix = " -t" },
        },
      },
    },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },

  extensions_list = {
    "live_grep_args",
    "ui-select",
    "hoogle",
    "fzf",
    "themes",
    "terms",
  },
}
