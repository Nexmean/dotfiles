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
         ["<leader>fr"] = { "<cmd> Telescope oldfiles <CR>", "   find recent files" },
         ["<leader>ds"] = { "<cmd> Telescope lsp_document_symbols <CR>", "   document symbols" },
         ["<leader>ws"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "   workspace symbols" },
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
         ["<leader>tx"] = { "<cmd> tabclose <CR>", "close tab"}
      }
   },
}
