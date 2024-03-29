return {
  {
    "Nexmean/caskey.nvim",
    -- dir = "~/programming/neovim/caskey.nvim",
    event = "VeryLazy",
    dependencies = { "folke/which-key.nvim" },
    config = function()
      local ck = require("caskey")
      local ckWk = require("caskey.wk")

      local cmd, cmdfn, ft, bt = ck.cmd, ck.cmdfn, ck.ft, ck.bt

      local lazy = require("util.lazy")
      local defer_call = lazy.defer_call

      -- local lsp = lazy.require("user.lsp")
      local hop = lazy.require("hop")
      local gs = lazy.require("gitsigns")
      -- local neotest = lazy.require("neotest")

      local function termcodes(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      local function map(args)
        if type(args) == "string" or type(args) == "function" then
          return { act = args }
        else
          local res = vim.tbl_extend("keep", args, {}) -- copy

          res.act = res[1] or res.act
          res.desc = res[2] or res.desc

          res[1] = nil
          res[2] = nil

          return res
        end
      end

      ckWk.setup({
        mode = "n", -- default modes
        silent = true,
        nowait = true,
        ["<Esc>"] = map({ cmd("noh"), "stop hlsearch", mode = "n" }),
        ["gd"] = map({ "<C-]>", "go to", when = ft("help"), noremap = true }),
        -- EDITOR
        {
          mode = "n",
          noremap = true,

          -- ["n"] = map(function()
          --   vim.cmd([[execute('normal! ' . v:count1 . 'n')]])
          --   require("hlslens").start()
          -- end),
          -- ["N"] = map(function()
          --   vim.cmd([[execute('normal! ' . v:count1 . 'N')]])
          --   require("hlslens").start()
          -- end),
        },
        {
          mode = { "i", "c" },

          ["<C-a>"] = map({ "<Home>", "Beginning of line" }),
          ["<C-e>"] = map({ "<End>", "End of line" }),
          ["<C-f>"] = map({ "<Right>", "Move forward" }),
          ["<C-b>"] = map({ "<Left>", "Move back" }),
          ["<C-d>"] = map({ "<Delete>", "Delete next character" }),
        },
        {
          mode = { "n", "v", "x" },

          {
            expr = true,

            j = map({ [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], "Move down" }),
            k = map({ [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], "Move up" }),
            ["<Down>"] = map({ [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], "move down" }),
            ["<Up>"] = map({ [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], "Move up" }),
          },

          ["s"] = map({ hop.hint_char2, "Hop 2 chars" }),
          ["gl"] = map({ hop.hint_lines, "Hop anywhere" }),
          ["gw"] = map({ hop.hint_words, "Hop anywhere" }),
        },
        ["<leader>u"] = map({ cmd("Telescope undo"), "undo tree", mode = "n" }),
        -- WINDOWS
        {
          mode = { "n", "v" },

          ["<C-h>"] = map({ cmd("TmuxNavigateLeft"), "Window left" }),
          ["<C-l>"] = map({ cmd("TmuxNavigateRight"), "Window right" }),
          ["<C-j>"] = map({ cmd("TmuxNavigateDown"), "Window down" }),
          ["<C-k>"] = map({ cmd("TmuxNavigateUp"), "Window up" }),
        },
        ["<C-w><C-w>"] = map({ cmd("PickAny"), "pick window" }),
        -- BUFFERS
        ["<leader>b"] = {
          name = "buffers",

          l = map({ cmd("Telescope buffers"), "list buffers" }),
          n = map({ cmd("enew"), "new buffer" }),
          x = map({ cmd("BRemove"), "close buffer" }),
        },
        ["~"] = map({ cmd("buffer #"), "recent buffer" }),
        ["gj"] = map({
          function()
            require("telescope.builtin").buffers({ sort_lastused = true })
          end,
          "list buffers",
        }),
        ["q"] = {
          act = cmd("close"),
          desc = "close window",
          when = {
            ft({
              "PlenaryTestPopup",
              "help",
              "lspinfo",
              "man",
              "notify",
              "qf",
              "spectre_panel",
              "startuptime",
              "tsplayground",
              "neotest-output",
              "checkhealth",
              "neotest-summary",
              "neotest-output-panel",
            }),
            bt({ "quickfix", "help" }),
          },
        },
        -- TABS
        ["gt"] = {
          name = "tabs",

          n = map({ cmd("tabnew"), "new tab" }),
          x = map({ cmd("tabclose"), "close tab" }),
          t = map({ cmd("Telescope telescope-tabs list_tabs"), "list tabs" }),
        },
        ["g1"] = map({ cmd("1tabnext"), "tab 1" }),
        ["g2"] = map({ cmd("2tabnext"), "tab 2" }),
        ["g3"] = map({ cmd("3tabnext"), "tab 3" }),
        ["g4"] = map({ cmd("4tabnext"), "tab 4" }),
        ["g5"] = map({ cmd("5tabnext"), "tab 5" }),
        ["g6"] = map({ cmd("6tabnext"), "tab 6" }),
        ["g7"] = map({ cmd("7tabnext"), "tab 7" }),
        ["g8"] = map({ cmd("8tabnext"), "tab 8" }),
        ["g9"] = map({ cmd("9tabnext"), "tab 9" }),

        -- TERMINAL
        ["<A-p>"] = {
          act = cmd("MprocsToggle"),
          desc = "toggle mprocs",
          mode = { "i", "n", "v", "t", "x", "c" },
        },
        ["<A-i>"] = {
          act = cmdfn("ToggleTerm"),
          desc = "toggle terminal",
          mode = { "i", "n", "v", "t", "x", "c" },
        },
        ["<C-x>"] = map({ termcodes("<C-\\><C-N>"), "escape terminal mode", mode = "t" }),
        -- LSP
        {
          mode = "n",

          when = "LspAttach",

          ["gD"] = map({ vim.lsp.buf.declaration, "lsp declaration" }),
          ["gd"] = map({ cmd("Telescope lsp_definitions"), "lsp definition" }),
          ["gi"] = map({ cmd("Telescope lsp_implementations"), "lsp implementations" }),
          ["gr"] = map({ cmd("Telescope lsp_references"), "lsp references" }),
          ["<A-k>"] = map({ vim.diagnostic.open_float, "hover diagnostic" }),
          ["K"] = map({ vim.lsp.buf.hover, "hover" }),
          ["<leader>D"] = map({ cmd("Telescope lsp_type_definitions"), "lsp definition type" }),
          ["<leader>c"] = {
            name = "code",

            a = map({ vim.lsp.buf.code_action, "lsp code action" }),
            f = map({ vim.lsp.buf.format, "lsp format" }),
            l = map({ vim.lsp.codelens.run, "lsp run codelens" }),
            r = map({ vim.lsp.buf.rename, "lsp rename" }),
            s = map({ vim.lsp.buf.signature_help, "lsp signature help" }),
          },

          ["<leader>d"] = {
            name = "diagnostics",

            b = map({ vim.diagnostic.setloclist, "buffer diagnostics" }),
            w = map({ vim.diagnostic.setqflist, "workspace diagnostics" }),
            t = {
              act = function()
                local current = vim.diagnostic.config()
                if current.virtual_lines == true then
                  vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
                else
                  vim.diagnostic.config({ virtual_lines = true, virtual_text = false })
                end
              end,
              desc = "toggle mutliline diagnostics",
            },
          },

          ["<leader>s"] = {
            name = "lsp symbols",

            w = map({ cmd("Telescope lsp_dynamic_workspace_symbols"), "lsp workspace symbols" }),
            d = map({ cmd("Telescope lsp_document_symbols"), "lsp document symbols" }),
            o = map({ cmd("Neotree document_symbols"), "lsp document symbols" }),
            n = map({ cmd("Navbuddy"), "lsp navigate symbols" }),
          },
        },

        -- TESTS
        -- ["<leader>t"] = {
        --   mode = "n",
        --   name = "tests",
        --
        --   when = ft({ "scala" }),
        --
        --   r = map({ neotest.run.run, "run nearest test" }),
        --   f = {
        --     act = function()
        --       neotest.run.run(vim.fn.expand("%"))
        --     end,
        --     desc = "run current buffer tests",
        --   },
        --   o = map({ neotest.output_panel.toggle, "toggle tests output" }),
        --   s = map({ neotest.summary.toggle, "toggle tests summary" }),
        --   x = map({ neotest.run.stop, "stop running tests" }),
        -- },
        -- GIT
        ["<A-g>"] = map({ cmd("LazyGitToggle"), "toggle LazyGit", mode = { "n", "t" } }),
        ["<leader>g"] = {
          name = "git",

          b = map({ cmd("Telescope git_branches"), "git branches" }),
          c = map({ cmd("Telescope git_commits"), "git commits" }),
          n = map({ cmd("Neogit"), "neogit" }),
          s = map({ cmd("Neotree git_status"), "git status" }),
        },
        {
          when = ck.emitted("Gitsigns"),

          ["<leader>h"] = {
            name = "hunk",

            s = {
              act = {
                n = gs.stage_hunk,
                v = defer_call(gs.stage_hunk, { vim.fn.line("."), vim.fn.line("v") }),
              },
              desc = "stage hunk",
            },
            r = {
              act = {
                n = gs.reset_hunk,
                v = defer_call(gs.reset_hunk, { vim.fn.line("."), vim.fn.line("v") }),
              },
              desc = "reset hunk",
            },
            S = map({ gs.stage_buffer, "stage buffer" }),
            u = map({ gs.undo_stage_hunk, "unstage hunk" }),
            p = map({ gs.preview_hunk, "preview hunk" }),
            b = map({ defer_call(gs.blame_line, { full = true }), "blame line" }),
            d = map({ gs.diffthis, "diff this" }),
            D = map({ defer_call(gs.diffthis, "~"), "diff this" }),
          },
        },
        ["ih"] = map({ ":<C-U>Gitsigns select_hunk<CR>", desc = "Hunk text object", mode = { "o", "x" } }),
        -- FIND
        ["<C-n>"] = map({ cmdfn("Neotree toggle"), "toggle neotree", mode = "n" }),
        ["<leader>e"] = map({ cmdfn("Neotree focus"), "focus neotree", mode = "n" }),
        ["<leader>f"] = {
          name = "find",

          a = map({ cmd("Telescope find_files follow=true no_ignore=true hidden=true"), "find all files" }),
          f = map({ cmd("Telescope find_files"), "find files" }),
          h = map({ cmd("Telescope help_tags"), "find help" }),
          o = map({ cmd("Telescope oldfiles only_cwd=true"), "find oldfiles" }),
          r = map({ cmd("Telescope resume"), "resume last search" }),
          w = {
            act = {
              n = function()
                require("telescope").extensions.live_grep_args.live_grep_args()
              end,
              v = function()
                local selected_text = require("util.selection").get_visual_selection()
                require("telescope").extensions.live_grep_args.live_grep_args({
                  default_text = selected_text,
                })
              end,
            },
            desc = "live grep",
          },
        },
        -- HASKELL
        {
          when = ft({ "haskell", "cabal" }),

          ["<A-r>"] = {
            act = function()
              require("haskell-tools").repl.toggle()
            end,
            desc = "package GHCi",
          },

          ["<leader>r"] = { name = "repl" },
          ["<leader>rf"] = {
            act = function()
              require("haskell-tools").repl.toggle(vim.api.nvim_buf_get_name(0))
            end,
            desc = "file GHCi",
          },
          ["<leader>rq"] = {
            act = function()
              require("haskell-tools").repl.quit()
            end,
            desc = "quit GHCi",
          },
        },

        -- Tasks
        ["<leader>t"] = {
          name = "tasks",

          ["r"] = map({ cmd("OverseerRun"), "run task" }),
          ["t"] = map({ cmd("OverseerToggle"), "toggle tasks" }),
        },
      })
    end,
  },
}
