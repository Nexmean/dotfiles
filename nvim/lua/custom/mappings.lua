return {
   nvterm_user = {
      -- macos fixes
      -- toggle in terminal mode
      t = {
         ["ˆ"] = { -- <A-i>
            function()
               require("nvterm.terminal").toggle "float"
            end,
            "   toggle floating term",
         },

         ["˙"] = { -- <A-h>
            function()
               require("nvterm.terminal").toggle "horizontal"
            end,
            "   toggle horizontal term",
         },

         ["√"] = { -- <A-v>
            function()
               require("nvterm.terminal").toggle "vertical"
            end,
            "   toggle vertical term",
         },
      },

      n = {
         -- toggle in normal mode
         ["ˆ"] = { -- <A-i>
            function()
               require("nvterm.terminal").toggle "float"
            end,
            "   toggle floating term",
         },

         ["˙"] = { -- <A-h>
            function()
               require("nvterm.terminal").toggle "horizontal"
            end,
            "   toggle horizontal term",
         },

         ["√"] = { -- <A-v>
            function()
               require("nvterm.terminal").toggle "vertical"
            end,
            "   toggle vertical term",
         },
      }
   },

   hop = (function ()
      local hop = function ()
         return require("hop")
      end

      local hop_hint = function ()
         return require("hop.hint")
      end

      return {
         v = {
            ["<leader><leader>k"] = {
               function ()
                  hop().hint_lines { direction = hop_hint().HintDirection.BEFORE_CURSOR }
               end,
               "hop line backward",
            },
            ["<leader><leader>j"] = {
               function ()
                  hop().hint_lines { direction = hop_hint().HintDirection.AFTER_CURSOR }
               end,
               "hop line forward",
            },
            ["<leader><leader>b"] = {
               function ()
                  hop().hint_words { direction = hop_hint().HintDirection.BEFORE_CURSOR }
               end,
               "hop word backward",
            },
            ["<leader><leader>w"] = {
               function ()
                  hop().hint_words { direction = hop_hint().HintDirection.AFTER_CURSOR }
               end,
               "hop word forward",
            },
         },
         n = {
            ["<leader><leader>k"] = {
               function ()
                  hop().hint_lines { direction = hop_hint().HintDirection.BEFORE_CURSOR }
               end,
               "hop line backward",
            },
            ["<leader><leader>j"] = {
               function ()
                  hop().hint_lines { direction = hop_hint().HintDirection.AFTER_CURSOR }
               end,
               "hop line forward",
            },
            ["<leader><leader>b"] = {
               function ()
                  hop().hint_words { direction = hop_hint().HintDirection.BEFORE_CURSOR }
               end,
               "hop word backward",
            },
            ["<leader><leader>w"] = {
               function ()
                  hop().hint_words { direction = hop_hint().HintDirection.AFTER_CURSOR }
               end,
               "hop word forward",
            },
         }
      }
   end)(),

   trouble_user = {
      n = {
         ["<leader>dd"] = { "<cmd> Trouble document_diagnostics <CR>", "Show document diagnostics" },
         ["<leader>wd"] = { "<cmd> Trouble workspace_diagnostics <CR>", "Show workspace diagnostics" },
         ["<leader>dh"] = { "<cmd> TroubleClose <CR>", "Hide diagnostics" },
      }
   },

   telescope_user = {
      n = {
         ["<leader>fd"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>",  "   find in current document" },
         ["<leader>fr"] = { "<cmd> Telescope resume <CR>",  "   repeat recent search" },
         ["<leader>fp"] = { "<cmd> Telescope pickers <CR>", "   find previous searches" },
         ["<leader>ds"] = { "<cmd> Telescope lsp_document_symbols <CR>", "   document symbols" },
         ["<leader>ws"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "   workspace symbols" },
         -- git
         ["<leader>gb"] = { "<cmd> Telescope git_branches <CR>", "  git branches" },
         ["<leader>gc"] = { "<cmd> Telescope git_commits <CR>", "  git commits" },
         ["<leader>gs"] = { "<cmd> Telescope git_stash <CR>", "  git stashes" },
         ["<leader>dc"] = { "<cmd> Telescope git_bcommits <CR>", "  git document commits" },
         -- lsp
         ["gi"] = { "<cmd> Telescope lsp_implementations <CR>", "   lsp implementation" },
         ["gr"] = { "<cmd> Telescope lsp_references <CR>", "   lsp references" },
         ["gd"] = { "<cmd> Telescope lsp_definitions <CR>", "   lsp definition" },
      },
      v = {
         ["<leader>fw"] = {
            function ()
               local selected_text = require("custom.utils.selection").get_visual_selection()
               require("telescope.builtin").live_grep { default_text = selected_text }
            end,
            "   live grep" ,
         }
      },
   },

   tabs_user = {
      n = {
         ["<leader>tx"] = { "<cmd> tabclose <CR>", "close tab" }
      }
   },

   persisted_user = {
      n = {
         ["<leader>ss"] = { "<cmd> SessionStart <CR>", "session start" },
         ["<leader>sl"] = { "<cmd> Telescope persisted <CR>", "session list" },
         ["<leader>sx"] = { "<cmd> SessionStop <CR>", "session stop" },
      },
   },

   telescope_frecency_user = {
      n = {
         ["<leader>fo"] = { "<cmd> Telescope frecency <CR>", "   find recent (old) files" }
      }
   },

   neogit_user = {
      n = {
         ["<leader>gn"] = { "<cmd> Neogit <CR> ", "  open neogit" }
      }
   },
}
