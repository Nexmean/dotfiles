local caskey = require("caskey")

local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function hop(method)
  return function()
    require("hop")[method]()
  end
end

local M = {}

M.general = {
  mode = {"n", "v"}, -- default modes

  ["<Esc>"] = {act = caskey.cmd "noh", desc = "no highlight", mode = "n"},
  -- MOVEMENTS
  {
    mode = {"i", "t", "c"},

    {
      ["<C-a>"] = {act = "<Home>"  , desc = "Beginning of line"},
      ["<C-e>"] = {act = "<End>"   , desc = "End of line"},
      ["<C-f>"] = {act = "<Right>" , desc = "Move forward"},
      ["<C-b>"] = {act = "<Left>"  , desc = "Move back"},
      ["<C-d>"] = {act = "<Delete>", desc = "Delete next character", mode = {"i", "c"}},
    },
  },
  {
    mode = {"n", "v", "x"},

    {
      expr = true,
      noremap = true,

      j          = {act = [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], desc = "Move down"},
      k          = {act = [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], desc = "Move up"},
      ["<Down>"] = {act = [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], desc = "move down"},
      ["<Up>"]   = {act = [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], desc = "Move up"},
    },
    ["ga"] = { act = hop "hint_char1", desc = "Hop anywhere" },
    ["gl"] = { act = hop "hint_lines", desc = "Hop line" },
    ["gw"] = { act = hop "hint_words", desc = "Hop word" },
  },

  -- WINDOWS
  {
    mode = {"n", "v"},

    ["<C-h>"]= {act = "<C-w>h", desc = "Window left"},
    ["<C-l>"]= {act = "<C-w>l", desc = "Window right"},
    ["<C-j>"]= {act = "<C-w>j", desc = "Window down"},
    ["<C-k>"]= {act = "<C-w>k", desc = "Window up"},
  },

  ["<C-w><C-w>"] = {act = caskey.cmd "PickAny", desc = "pick window"},

  -- BUFFERS
  ["<leader>b"] = {
    name = "buffers",

    l = {act = caskey.cmd "Telescope buffers", desc = "list buffers"},
    n = {act = caskey.cmd "enew"             , desc = "new buffer"},
    x = {act = caskey.cmd "BRemove"          , desc = "close buffer"},
  },

  ["~"] = {act = caskey.cmd "buffer #", desc = "recent buffer"},
  ["gj"] = {act = caskey.cmd "Telescope buffers", desc = "list buffers"},
  ["q"] = {
    act = caskey.cmd "close",
    desc = "close window",
    buf_local = {
      caskey.ft "Outline",
      caskey.bt {"quickfix", "help"},
    },
  },

  -- TABS
  ["<leader>t"] = {
    name = "tabs",

    n = {act = caskey.cmd "tabnew"                            , desc = "new tab"},
    x = {act = caskey.cmd "tabclose"                          , desc = "close tab"},
    t = {act = caskey.cmd "Telescope telescope-tabs list_tabs", desc = "list tabs"},
  },

  {
    ["g1"] = {act = caskey.cmd "1tabnext", desc = "tab 1"},
    ["g2"] = {act = caskey.cmd "2tabnext", desc = "tab 2"},
    ["g3"] = {act = caskey.cmd "3tabnext", desc = "tab 3"},
    ["g4"] = {act = caskey.cmd "4tabnext", desc = "tab 4"},
    ["g5"] = {act = caskey.cmd "5tabnext", desc = "tab 5"},
    ["g6"] = {act = caskey.cmd "6tabnext", desc = "tab 6"},
    ["g7"] = {act = caskey.cmd "7tabnext", desc = "tab 7"},
    ["g8"] = {act = caskey.cmd "8tabnext", desc = "tab 8"},
    ["g9"] = {act = caskey.cmd "9tabnext", desc = "tab 9"},
  },

  -- TERMINAL
  ["<A-i>"] = {
    act = caskey.cmd "TermToggle",
    desc = "toggle terminal",
    mode = {"i", "n", "v", "t", "x", "c"}
  },
  ["<C-x>"] = {act = termcodes "<C-\\><C-N>", desc = "escape terminal mode", mode = "t"},

  -- LSP
  {
    mode = "n",

    buf_local = {{event = "LspAttach"}},

    ["gD"] = {act = vim.lsp.buf.declaration               , desc = "lsp declaration"},
    ["gd"] = {act = caskey.cmd "Telescope lsp_definitions", desc = "lsp definition"},
    ["gi"] = {
      act = caskey.cmd "Telescope lsp_implementations",
      desc = "lsp implementations"
    },
    ["gr"] = {act = caskey.cmd "Telescope lsp_references", desc = "lsp references"},
    ["<A-k>"] = {act = vim.diagnostic.open_float         , desc = "hover diagnostic"},
    ["<leader>D"] = {
      act = caskey.cmd "Telescope lsp_type_definitions",
      desc = "lsp definition type"
    },
    ["<leader>c"] = {
      name = "code",

      a = {act = vim.lsp.buf.code_action   , desc = "lsp code action"},
      r = {act = vim.lsp.buf.rename        , desc = "lsp rename"},
      s = {act = vim.lsp.buf.signature_help, desc = "lsp signature help"},
    },

    ["<leader>d"] = {
      name = "diagnostics",

      b = {act = vim.diagnostic.setloclist, desc = "buffer diagnostics"},
      w = {act = vim.diagnostic.setqflist , desc = "workspace diagnostics"},
      t = {
        act = function ()
          local current = vim.diagnostic.config()
          if current.virtual_lines == true then
            vim.diagnostic.config {virtual_lines = false, virtual_text = true}
          else
            vim.diagnostic.config {virtual_lines = true, virtual_text = false}
          end
        end,
        desc = "toggle mutliline diagnostics"
      }
    },

    ["<leader>s"] = {
      name = "lsp symbols",

      w = {
        act = caskey.cmd "Telescope lsp_dynamic_workspace_symbols",
        desc = "lsp workspace symbols"
      },
      d = {
        act = caskey.cmd "Telescope lsp_document_symbols",
        desc = "lsp document symbols"
      },
    },

    ["<C-s>"] = {
      act = caskey.cmd "SymbolsOutline",
      desc = "toggle outline",

      buf_local_extend = {caskey.ft "Outline"},
    },
  },

  -- GIT
  ["<leader>g"] = {
    name = "git",

    b = {act = caskey.cmd "Telescope git_branches", desc = "git branches"},
    c = {act = caskey.cmd "Telescope git_commits" , desc = "git commits"},
    n = {act = caskey.cmd "Neogit"                , desc = "neogit"},
    s = {act = caskey.cmd "Telescope git_status"  , desc = "git status"},
  },

  ["ih"] = {
    mode = {"o", "x"},
    act = ":<C-U>Gitsigns select_hunk<CR>"
  },

  -- FIND
  ["<C-n>"] = {act = caskey.cmd "Neotree toggle", desc = "toggle neotree", mode = "n"},

  ["<leader>f"] = {
    name = "find",

    a = {
      act = caskey.cmd "Telescope find_files follow=true no_ignore=true hidden=true",
      desc = "find all files"
    },
    f = {act = caskey.cmd "Telescope find_files"            , desc = "find files"},
    h = {act = caskey.cmd "Telescope help_tags"             , desc = "find help"},
    o = {act = caskey.cmd "Telescope oldfiles only_cwd=true", desc = "find oldfiles"},
    r = {act = caskey.cmd "Telescope resume"                , desc = "resume last search"},
    w = {
      act = {
        n = function ()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        v = function ()
          local selected_text = require("user.common.selection").get_visual_selection()
          require("telescope")
            .extensions.live_grep_args.live_grep_args { default_text = selected_text }
        end,
      },
      desc = "live grep",
    },
  },

  -- HASKELL
  {
    buf_local = {caskey.ft {"haskell", "cabal"}},

    ["<A-r>"] = {
      act = function ()
        require("haskell-tools").repl.toggle()
      end,
      desc = "package GHCi"
    },

    ["<leader>r"] = {
      name = "repl",

      f = {
        act = function()
          require("haskell-tools").repl.toggle(vim.api.nvim_buf_get_name(0))
        end,
        desc = "file GHCi",
      },

      q = {
        act = function ()
          require("haskell-tools").repl.quit()
        end,
        desc = "quit GHCi",
      },
    },
  },
}

M.gitsigns = {
  mode = {"n", "v"},

  ["<leader>h"] = function ()
    local gs = require("gitsigns")

    return {
      name = "hunk",

      s = {
        act = {
          n = gs.stage_hunk,
          v = function ()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end
        },
        desc = "stage hunk",
      },
      r = {
        act = {
          n = gs.reset_hunk,
          v = function ()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end
        },
        desc = "rest hunk",
      },
      {
        mode = "n",

        S = {act = gs.stage_buffer, desc = "stage buffer"},
        u = {act = gs.undo_stage_hunk, desc = "unstage hunk"},
        d = {act = gs.preview_hunk, desc = "preview hunk"},
        b = {
          act = function ()
            gs.blame_line {full = true}
          end,
          desc = "blame line"
        },
      },
    }
  end,
}

return M
