return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-file-browser.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-media-files.nvim" },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      { "nvim-tree/nvim-web-devicons" },
      { "ahmedkhalf/project.nvim" },
      { "olimorris/persisted.nvim" },
      { "debugloop/telescope-undo.nvim" },
    },
    cmd = { "Telescope" },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_set = require("telescope.actions.set")
      local action_state = require("telescope.actions.state")
      local config = require("telescope.config.resolve")
      local lga_actions = require("telescope-live-grep-args.actions")

      require("plugins.telescope.layouts").setup({
        horizontal_collapsed = {
          height = config.resolve_height(0.9),
          width = config.resolve_width({ 0.9, max = 210 }),
          preview_width = config.resolve_width({ 0.5, max = 100 }),
          preview_cutoff = 100,
        },
        vertical_collapsed = {
          height = config.resolve_height(0.9),
          width = config.resolve_width({ 0.9, max = 150 }),
          preview_cutoff = 30,
          preview_height = config.resolve_height(0.4),
        },
      })

      telescope.setup({
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
          prompt_prefix = " ",
          selection_caret = " ",
          entry_prefix = "  ",
          initial_mode = "insert",
          results_title = false,
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "vertical_collapsed",
          layout_config = {
            height = 0.9,
            width = { 0.9, max = 150 },
            preview_height = 0.4,
          },
          path_display = {
            "absolute",
          },
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          file_ignore_patterns = {},
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          winblend = 0,
          border = true,
          borderchars = {
            prompt = { "─", "│", "", "│", "┌", "┐", "", "" },
            results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
            preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          },
          color_devicons = true,
          use_less = true,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

          -- Developer configurations: Not meant for general override
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
          mappings = {
            i = {
              ["<c-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<c-b>"] = actions.preview_scrolling_up,
              ["<c-f>"] = actions.preview_scrolling_down,
              ["<c-j>"] = false,
              ["<C-CR>"] = function(prompt_bufnr)
                action_set.edit(prompt_bufnr, "Pick")
              end,
            },
            n = {
              ["<c-b>"] = actions.preview_scrolling_up,
              ["<c-f>"] = actions.preview_scrolling_down,
              ["<C-CR>"] = function(prompt_bufnr)
                action_set.edit(prompt_bufnr, "Pick")
              end,
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
          find_files = {
            results_title = false,
          },
          git_files = {
            results_title = false,
          },
          git_status = {
            expand_dir = false,
          },
          git_commits = {
            mappings = {
              i = {
                ["<C-M-d>"] = function()
                  -- Open in diffview
                  local selected_entry = action_state.get_selected_entry()
                  local value = selected_entry.value
                  -- close Telescope window properly prior to switching windows
                  vim.api.nvim_win_close(0, true)
                  vim.cmd("stopinsert")
                  vim.schedule(function()
                    vim.cmd(("DiffviewOpen %s^!"):format(value))
                  end)
                end,
              },
            },
          },
          current_buffer_fuzzy_find = {
            tiebreak = function(a, b)
              -- Sort tiebreaks by line number
              return a.lnum < b.lnum
            end,
          },
        },
        extensions = {
          file_browser = {
            -- theme = "ivy",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            mappings = {
              ["i"] = {
                -- your custom insert mode mappings
              },
              ["n"] = {
                -- your custom normal mode mappings
              },
            },
          },
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = false, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          media_files = {
            -- filetypes whitelist
            -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
            filetypes = { "png", "webp", "jpg", "jpeg", "mp4", "webm", "pdf" },
            find_cmd = "fd",
            -- find_cmd = "rg" -- find command (defaults to `fd`)
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-l>g"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                ["<C-l>t"] = lga_actions.quote_prompt({ postfix = " -t" }),
              },
            },
          },
        },
      })

      -- Load extensions
      require("telescope").load_extension("notify")
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("media_files")
      require("telescope").load_extension("projects")
      require("telescope").load_extension("persisted")
      require("telescope").load_extension("undo")
      require("telescope").load_extension("file_browser")
    end,
  },

  {
    "LukasPietzschmann/telescope-tabs",
    lazy = true,
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      show_preview = false,
    },
  },
}
