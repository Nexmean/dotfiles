-- n, v, i, t = mode names

local function termcodes(str)
   return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local M = {}

M.general = {
   i = {

      -- go to  beginning and end
      ["<C-b>"] = { "<ESC>^i", "論 beginning of line" },
      ["<C-e>"] = { "<End>", "壟 end of line" },

      -- navigate within insert mode
      ["<C-h>"] = { "<Left>", "  move left" },
      ["<C-l>"] = { "<Right>", " move right" },
      ["<C-j>"] = { "<Down>", " move down" },
      ["<C-k>"] = { "<Up>", " move up" },
   },

   n = {

      ["<ESC>"] = { "<cmd> noh <CR>", "  no highlight" },

      -- switch between windows
      ["<C-h>"] = { "<C-w>h", " window left" },
      ["<C-l>"] = { "<C-w>l", " window right" },
      ["<C-j>"] = { "<C-w>j", " window down" },
      ["<C-k>"] = { "<C-w>k", " window up" },

      -- save
      ["<C-s>"] = { "<cmd> w <CR>", "﬚  save file" },

      -- Copy all
      ["<C-c>"] = { "<cmd> %y+ <CR>", "  copy whole file" },

      -- line numbers
      ["<leader>n"] = { "<cmd> set nu! <CR>", "   toggle line number" },
      ["<leader>rn"] = { "<cmd> set rnu! <CR>", "   toggle relative number" },

      -- update nvchad
      ["<leader>uu"] = { "<cmd> :NvChadUpdate <CR>", "  update nvchad" },

      ["<leader>tt"] = {
         function()
            require("base46").toggle_theme()
         end,

         "   toggle theme",
      },

      -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
      -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
      -- empty mode is same as using <cmd> :map
      -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
      ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
      ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
      ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
      ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
   },

   t = {
      ["<C-x>"] = { termcodes "<C-\\><C-N>", "   escape terminal mode" },
   },

   v = {
      ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
      ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
      ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
      ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
      -- Don't copy the replaced text after pasting in visual mode
      -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
      ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', opts = { silent = true } },
   },
}

M.tabufline = {

   n = {
      -- new buffer
      ["<S-b>"] = { "<cmd> enew <CR>", "烙 new buffer" },

      -- cycle through buffers
      ["<TAB>"] = { "<cmd> Tbufnext <CR>", "  goto next buffer" },
      ["<S-Tab>"] = { "<cmd> Tbufprev <CR> ", "  goto prev buffer" },

      -- cycle through tabs
      ["<leader>tp"] = { "<cmd> tabprevious <CR>", "  goto next tab" },
      ["<leader>tn"] = { "<cmd> tabnext <CR> ", "  goto prev tab" },

      -- close buffer + hide terminal buffer
      ["<leader>x"] = {
         function()
            require("core.utils").close_buffer()
         end,
         "   close buffer",
      },
   },
}

M.comment = {

   -- toggle comment in both modes
   n = {
      ["<leader>/"] = {
         function()
            require("Comment.api").toggle_current_linewise()
         end,

         "蘒  toggle comment",
      },
   },

   v = {
      ["<leader>/"] = {
         "<ESC><cmd>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>",
         "蘒  toggle comment",
      },
   },
}

M.lspconfig = {
   -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

   n = {
      ["gD"] = {
         function()
            vim.lsp.buf.declaration()
         end,
         "   lsp declaration",
      },

      ["K"] = {
         function()
            vim.lsp.buf.hover()
         end,
         "   lsp hover",
      },

      ["<leader>ls"] = {
         function()
            vim.lsp.buf.signature_help()
         end,
         "   lsp signature_help",
      },

      ["<leader>D"] = {
         function()
            vim.lsp.buf.type_definition()
         end,
         "   lsp definition type",
      },

      ["<leader>ra"] = {
         function()
            vim.lsp.buf.rename()
         end,
         "   lsp rename",
      },

      ["<leader>ca"] = {
         function()
            vim.lsp.buf.code_action()
         end,
         "   lsp code_action",
      },

      ["<leader>f"] = {
         function()
            vim.diagnostic.open_float()
         end,
         "   floating diagnostic",
      },

      ["[d"] = {
         function()
            vim.diagnostic.goto_prev()
         end,
         "   goto prev",
      },

      ["d]"] = {
         function()
            vim.diagnostic.goto_next()
         end,
         "   goto_next",
      },

      ["<leader>q"] = {
         function()
            vim.diagnostic.setloclist()
         end,
         "   diagnostic setloclist",
      },

      ["<leader>fm"] = {
         function()
            vim.lsp.buf.formatting()
         end,
         "   lsp formatting",
      },

      ["<leader>wa"] = {
         function()
            vim.lsp.buf.add_workspace_folder()
         end,
         "   add workspace folder",
      },

      ["<leader>wr"] = {
         function()
            vim.lsp.buf.remove_workspace_folder()
         end,
         "   remove workspace folder",
      },

      ["<leader>wl"] = {
         function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
         end,
         "   list workspace folders",
      },
   },
}

M.nvimtree = {

   n = {
      -- toggle
      ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "   toggle nvimtree" },

      -- focus
      ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "   focus nvimtree" },
   },
}

M.telescope = {
   n = {
      -- find
      ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "  find files" },
      ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "  find all" },
      ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "   live grep" },
      ["<leader>fb"] = { "<cmd> Telescope buffers sort_lastused=true <CR>", "  find buffers" },
      ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "  help page" },
      ["<leader>fo"] = { "<cmd> Telescope frecency <CR>", "   find recent (old) files" },
      ["<leader>tk"] = { "<cmd> Telescope keymaps <CR>", "   show keys" },
      ["<leader>fd"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>",  "   find in current document" },
      ["<leader>fr"] = { "<cmd> Telescope resume <CR>",  "   repeat recent search" },
      ["<leader>fp"] = { "<cmd> Telescope pickers <CR>", "   find previous searches" },

      -- git
      ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "   git commits" },
      ["<leader>dc"] = { "<cmd> Telescope git_bcommits <CR>", "  git document commits" },
      ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "  git status" },
      ["<leader>gb"] = { "<cmd> Telescope git_branches <CR>", "  git branches" },
      ["<leader>gc"] = { "<cmd> Telescope git_commits <CR>", "  git commits" },
      ["<leader>gs"] = { "<cmd> Telescope git_stash <CR>", "  git stashes" },

      -- lsp
      ["gi"] = { "<cmd> Telescope lsp_implementations <CR>", "   lsp implementation" },
      ["gr"] = { "<cmd> Telescope lsp_references <CR>", "   lsp references" },
      ["gd"] = { "<cmd> Telescope lsp_definitions <CR>", "   lsp definition" },
      ["<leader>ds"] = { "<cmd> Telescope lsp_document_symbols <CR>", "   document symbols" },
      ["<leader>ws"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "   workspace symbols" },

      -- pick a hidden term
      ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "   pick hidden term" },

      -- theme switcher
      ["<leader>th"] = { "<cmd> Telescope themes <CR>", "   nvchad themes" },
   },
   v = {

   },
}

M.nvterm = {
   t = {
      -- toggle in terminal mode
      ["<A-s>"] = {
         function()
            require("nvterm.terminal").toggle "horizontal"
         end,
         "   toggle horizontal term",
      },

      ["<A-v>"] = {
         function()
            require("nvterm.terminal").toggle "vertical"
         end,
         "   toggle vertical term",
      },

      ["ß"] = { -- <A-h>
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
      ["<A-s>"] = {
         function()
            require("nvterm.terminal").toggle "horizontal"
         end,
         "   toggle horizontal term",
      },

      ["<A-v>"] = {
         function()
            require("nvterm.terminal").toggle "vertical"
         end,
         "   toggle vertical term",
      },

      ["ß"] = { -- <A-h>
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
}

M.whichkey = {
   n = {
      ["<leader>wK"] = {
         function()
            vim.cmd "WhichKey"
         end,
         "   which-key all keymaps",
      },
      ["<leader>wk"] = {
         function()
            local input = vim.fn.input "WhichKey: "
            vim.cmd("WhichKey " .. input)
         end,
         "   which-key query lookup",
      },
   },
}

M.blankline = {
   n = {
      ["<leader>bc"] = {
         function()
            local ok, start = require("indent_blankline.utils").get_current_context(
               vim.g.indent_blankline_context_patterns,
               vim.g.indent_blankline_use_treesitter_scope
            )

            if ok then
               vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
               vim.cmd [[normal! _]]
            end
         end,

         "  Jump to current_context",
      },
   },
}

M.hop = {
   v = {
      ["gl"] = {
         function ()
            require("hop").hint_lines {}
         end,
         "hop line",
      },
      ["gw"] = {
         function ()
            require("hop").hint_words {}
         end,
         "hop word",
      },
   },
   n = {
      ["gl"] = {
         function ()
            require("hop").hint_lines {}
         end,
         "hop line",
      },
      ["gw"] = {
         function ()
            require("hop").hint_words {}
         end,
         "hop word",
      },
   }
}

M.trouble = {
   n = {
      ["<leader>dd"] = { "<cmd> Trouble document_diagnostics <CR>", "Show document diagnostics" },
      ["<leader>wd"] = { "<cmd> Trouble workspace_diagnostics <CR>", "Show workspace diagnostics" },
      ["<leader>dh"] = { "<cmd> TroubleClose <CR>", "Hide diagnostics" },
   }
}

M.tabs = {
   n = {
      ["<leader>tx"] = { "<cmd> tabclose <CR>", "close tab" }
   }
}

M.persisted = {
   n = {
      ["<leader>ss"] = { "<cmd> SessionStart <CR>", "session start" },
      ["<leader>sl"] = { "<cmd> Telescope persisted <CR>", "session list" },
      ["<leader>sx"] = { "<cmd> SessionStop <CR>", "session stop" },
   },
}

M.neogit = {
   n = {
      ["<leader>gn"] = { "<cmd> Neogit <CR> ", "  open neogit" }
   }
}

local goto_parent = function ()
   require("tree-climber").goto_parent()
end

local goto_child = function ()
   require("tree-climber").goto_child()
end

local goto_prev = function ()
   require("tree-climber").goto_prev()
end

local goto_next = function ()
   require("tree-climber").goto_next()
end

M.tree_climber = {
   n = {
      ["<A-h>"] = {goto_parent, "go to parent"},
      ["˙"]     = {goto_parent, "go to parent"},
      ["<A-l>"] = {goto_child, "go to child"},
      ["¬"]     = {goto_child, "go to child"},
      ["<A-k>"] = {goto_prev, "go to prev"},
      ["˚"]     = {goto_prev, "go to prev"},
      ["<A-j>"] = {goto_next, "go to next"},
      ["∆"]     = {goto_next, "go to next"},
   }
}

return M
