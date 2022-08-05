local actions = require "telescope.actions"
local lga_actions = require "telescope-live-grep-args.actions"

local options = {
   defaults = {
      vimgrep_arguments = {
         "rg",
         "--color=never",
         "--no-heading",
         "--with-filename",
         "--line-number",
         "--column",
         "--smart-case",
      },
      prompt_prefix = "   ",
      selection_caret = "  ",
      entry_prefix = "  ",
      initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
         horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
         },
         vertical = {
            mirror = false,
         },
         width = 0.80,
         height = 0.80,
         preview_cutoff = 120,
      },
      file_sorter = require("telescope.sorters").get_fuzzy_file,
      file_ignore_patterns = { "node_modules" },
      generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      path_display = { "truncate" },
      winblend = 0,
      border = {},
      borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      color_devicons = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      -- Developer configurations: Not meant for general override
      buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
      mappings = {
         i = {
            ["<C-v>"] = actions.select_vertical,
            ["<C-s>"] = actions.select_horizontal,
            ["<C-q>"] = actions.close,
         },
         n = {
            ["<C-v>"] = actions.select_vertical,
            ["<C-s>"] = actions.select_horizontal,
            ["<C-q>"] = actions.close,
         },
      },
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
   },
}

-- check for any override
return options
