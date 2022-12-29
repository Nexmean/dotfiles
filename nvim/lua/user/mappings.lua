local utils = require("user.common.utils")

local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function hop(method)
  return function()
    require("hop")[method]()
  end
end


return {
  mode = {"n", "v"}, -- default modes

  -- MOVEMENTS
  {
    mode = {"i", "t", "c"},

    {
      ["<C-a>"]= {act = "<Home>", desc = "beginning of line"},
      ["<C-e>"]= {act = "<End>", desc = "end of line"},
      ["<C-f>"]= {act = "<Right>", desc = "move forward"},
      ["<C-b>"]= {act = "<Left>", desc = "move back"},
      ["<C-d>"]= {act = "<Delete>", desc = "delete next character", mode = {"i", "c"}},
    },
  },
  {
    mode = {"n", "v", "x"},

    {
      expr = true,
      noremap = true,

      j = {act = [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], desc = "move down"},
      k = {act = [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], desc = "move up"},
      ["<Down>"] = {
        act = [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]],
        desc = "move up"
      },
      ["<Up>"] = {act = [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], desc = "move up"},
    },
    ["ga"] = { act = hop "hint_char1", desc = "hop anywhere" },
    ["gl"] = { act = hop "hint_lines", desc = "hop line" },
    ["gw"] = { act = hop "hint_words", desc = "hop word" },
  },

  -- WINDOWS
  {
    mode = {"n", "v", "t"},

    ["<C-h>"]= {act = "<C-w>h", desc = "window left"},
    ["<C-l>"]= {act = "<C-w>l", desc = "window right"},
    ["<C-j>"]= {act = "<C-w>j", desc = "window down"},
    ["<C-k>"]= {act = "<C-w>k", desc = "window up"},
  },

  ["<C-w><C-w>"] = {act = utils.cmd "PickAny", desc = "pick window", mode = {"n", "v"}},

  -- BUFFERS
  ["<leader>b"] = {
    name = "buffers",

    l = {act = utils.cmd "Telescope buffers", desc = "list buffers"},
    n = {act = utils.cmd "enew", desc = "new buffer"},
    x = {act = utils.cmd "BRemove", desc = "close buffer"},
  },

  ["~"] = {act = utils.cmd "buffer #", desc = "recent buffer"},
  ["gj"] = {act = utils.cmd "Telescope buffers", desc = "list buffers"},
  ["q"] = {
    act = utils.cmd "close",
    desc = "close window",
    buf_local = {
      {
        event = {"BufEnter", "BufWinEnter"},
        condition = function ()
          return vim.o.buftype == "quickfix" or vim.o.buftype == "help"
        end,
      },
    },
  },

  -- TABS
  ["<leader>t"] = {
    name = "tabs",

    n = {act = utils.cmd "tabnew", desc = "new tab"},
    x = {act = utils.cmd "tabclose", desc = "close tab"},
    t = {act = utils.cmd "Telescope telescope-tabs list_tabs", desc = "list tabs"},
  },

  {
    ["g1"] = {act = utils.cmd "1tabnext", desc = "tab 1"},
    ["g2"] = {act = utils.cmd "2tabnext", desc = "tab 2"},
    ["g3"] = {act = utils.cmd "3tabnext", desc = "tab 3"},
    ["g4"] = {act = utils.cmd "4tabnext", desc = "tab 4"},
    ["g5"] = {act = utils.cmd "5tabnext", desc = "tab 5"},
    ["g6"] = {act = utils.cmd "6tabnext", desc = "tab 6"},
    ["g7"] = {act = utils.cmd "7tabnext", desc = "tab 7"},
    ["g8"] = {act = utils.cmd "8tabnext", desc = "tab 8"},
    ["g9"] = {act = utils.cmd "9tabnext", desc = "tab 9"},
  },

  -- TERMINAL
  ["<A-i>"] = {
    act = utils.cmd "TermToggle",
    desc = "toggle terminal",
    mode = {"i", "n", "v", "t", "x", "c"}
  },
  ["<C-x>"] = {act = termcodes "<C-\\><C-N>", desc = "escape terminal mode", mode = "t"},

  -- LSP
  {
    mode = "n",

    buf_local = {
      {event = "LspAttach"}
    },

    ["gD"] = {act = vim.lsp.buf.declaration, desc = "lsp declaration"},
    ["gd"] = {act = utils.cmd "Telescope lsp_definitions", desc = "lsp definition"},
    ["gi"] = {
      act = utils.cmd "Telescope lsp_implementations",
      desc = "lsp implementations"
    },
    ["gr"] = {act = utils.cmd "Telescope lsp_references", desc = "lsp references"},
    ["<A-k>"] = {act = vim.diagnostic.open_float, desc = "hover diagnostic"},
    ["<leader>D"] = {
      act = utils.cmd "Telescope lsp_type_definitions",
      desc = "lsp definition type"
    },
    ["<leader>c"] = {
      name = "code",

      a = {act = vim.lsp.buf.code_action, desc = "lsp code action"},
      r = {act = vim.lsp.buf.rename, desc = "lsp rename"},
      s = {act = vim.lsp.buf.signature_help, desc = "lsp signature help"},
    },

    ["<leader>d"] = {
      name = "diagnostics",

      b = {act = vim.diagnostic.setloclist, desc = "buffer diagnostics"},
      w = {act = vim.diagnostic.setqflist, desc = "workspace diagnostics"},
    },

    ["<leader>s"] = {
      name = "lsp symbols",

      w = {
        act = utils.cmd "Telescope lsp_dynamic_workspace_symbols",
        desc = "lsp workspace symbols"
      },
      d = {
        act = utils.cmd "Telescope lsp_document_symbols",
        desc = "lsp document symbols"
      },
    },

    ["<C-s>"] = {
      act = utils.cmd "SymbolsOutline",
      desc = "toggle outline",

      buf_local_extend = {
        {event = "FileType", pattern = "Outline"},
      },
    },
  },

  -- GIT
  ["<leader>g"] = {
    name = "git",

    mode = {"n", "v"},

    b = {act = utils.cmd "Telescope git_branches", desc = "git branches"},
    c = {act = utils.cmd "Telescope git_commits", desc = "git commits"},
    n = {act = utils.cmd "Neogit", desc = "neogit"},
    s = {act = utils.cmd "Telescope git_status", desc = "git status"},
  },

  -- FIND
  ["<C-n>"] = {act = utils.cmd "Neotree toggle", desc = "toggle neotree", mode = "n"},

  ["<leader>f"] = {
    name = "find",

    mode = {"n", "v"},

    a = {
      act = utils.cmd "Telescope find_files follow=true no_ignore=true hidden=true",
      desc = "find all files"
    },
    f = {act = utils.cmd "Telescope find_files", desc = "find files"},
    h = {act = utils.cmd "Telescope help_tags", desc = "find help"},
    o = {act = utils.cmd "Telescope oldfiles only_cwd=true", desc = "find oldfiles"},
    r = {act = utils.cmd "Telescope resume", desc = "resume last search"},
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
    name = "haskell",

    mode = {"n", "v"},
    buf_local = {
      {event = "FileType", pattern = {"haskell", "cabal"}},
    },

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
