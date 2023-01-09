local ck = require "caskey"
local utils = require "user.common.utils"

local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local M = {}

M.general = {
  mode = "n", -- default modes
  silent = true,
  nowait = true,

  ["<Esc>"] = { act = ck.cmd "noh", desc = "no highlight", mode = "n" },
  ["gd"] = { act = "<C-]>", desc = "go to", when = ck.ft "help" },

  -- MOVEMENTS
  {
    mode = { "i", "t", "c" },

    ["<C-a>"] = { act = "<Home>", desc = "Beginning of line" },
    ["<C-e>"] = { act = "<End>", desc = "End of line" },
    ["<C-f>"] = { act = "<Right>", desc = "Move forward" },
    ["<C-b>"] = { act = "<Left>", desc = "Move back" },
    ["<C-d>"] = { act = "<Delete>", desc = "Delete next character", mode = { "i", "c" } },
  },
  {
    mode = { "n", "v", "x" },

    {
      expr = true,

      j = { act = [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], desc = "Move down" },
      k = { act = [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], desc = "Move up" },
      ["<Down>"] = { act = [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], desc = "move down" },
      ["<Up>"] = { act = [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], desc = "Move up" },
    },

    function()
      local function hop(method)
        return function()
          require("hop")[method]()
        end
      end

      return {
        ["ga"] = { act = hop "hint_char1", desc = "Hop anywhere" },
        ["gl"] = { act = hop "hint_lines", desc = "Hop line" },
        ["gw"] = { act = hop "hint_words", desc = "Hop word" },
      }
    end,
  },

  -- WINDOWS
  {
    mode = { "n", "v" },

    ["<C-h>"] = { act = "<C-w>h", desc = "Window left" },
    ["<C-l>"] = { act = "<C-w>l", desc = "Window right" },
    ["<C-j>"] = { act = "<C-w>j", desc = "Window down" },
    ["<C-k>"] = { act = "<C-w>k", desc = "Window up" },
  },

  ["<C-w><C-w>"] = { act = ck.cmd "PickAny", desc = "pick window" },

  -- BUFFERS
  ["<leader>b"] = {
    name = "buffers",

    l = { act = ck.cmd "Telescope buffers", desc = "list buffers" },
    n = { act = ck.cmd "enew", desc = "new buffer" },
    x = { act = ck.cmd "BRemove", desc = "close buffer" },
  },
  {
    mode = { "n", "v", "i" },

    ["<C-,>"] = { act = ck.cmdfn "CybuLastusedNext", desc = "prev buffer" },
    ["<C-.>"] = { act = ck.cmdfn "CybuLastusedPrev", desc = "next buffer" },
  },

  ["~"] = { act = ck.cmd "buffer #", desc = "recent buffer" },
  ["gj"] = { act = ck.cmd "Telescope buffers", desc = "list buffers" },
  ["q"] = {
    act = ck.cmd "close",
    desc = "close window",
    when = {
      ck.ft "Outline",
      ck.bt { "quickfix", "help" },
    },
  },

  -- TABS
  ["<leader>t"] = {
    name = "tabs",

    n = { act = ck.cmd "tabnew", desc = "new tab" },
    x = { act = ck.cmd "tabclose", desc = "close tab" },
    t = { act = ck.cmd "Telescope telescope-tabs list_tabs", desc = "list tabs" },
  },

  {
    ["g1"] = { act = ck.cmd "1tabnext", desc = "tab 1" },
    ["g2"] = { act = ck.cmd "2tabnext", desc = "tab 2" },
    ["g3"] = { act = ck.cmd "3tabnext", desc = "tab 3" },
    ["g4"] = { act = ck.cmd "4tabnext", desc = "tab 4" },
    ["g5"] = { act = ck.cmd "5tabnext", desc = "tab 5" },
    ["g6"] = { act = ck.cmd "6tabnext", desc = "tab 6" },
    ["g7"] = { act = ck.cmd "7tabnext", desc = "tab 7" },
    ["g8"] = { act = ck.cmd "8tabnext", desc = "tab 8" },
    ["g9"] = { act = ck.cmd "9tabnext", desc = "tab 9" },
  },

  -- TERMINAL
  ["<A-i>"] = {
    act = utils.cmdfn "TermToggle",
    desc = "toggle terminal",
    mode = { "i", "n", "v", "t", "x", "c" },
  },
  ["<C-x>"] = { act = termcodes "<C-\\><C-N>", desc = "escape terminal mode", mode = "t" },

  -- LSP
  {
    mode = "n",

    when = "LspAttach",

    ["gD"] = { act = vim.lsp.buf.declaration, desc = "lsp declaration" },
    ["gd"] = { act = ck.cmd "Telescope lsp_definitions", desc = "lsp definition" },
    ["gi"] = {
      act = ck.cmd "Telescope lsp_implementations",
      desc = "lsp implementations",
    },
    ["gr"] = { act = ck.cmd "Telescope lsp_references", desc = "lsp references" },
    ["<A-k>"] = { act = vim.diagnostic.open_float, desc = "hover diagnostic" },
    ["K"] = { act = vim.lsp.buf.hover, desc = "hover" },
    ["<leader>D"] = {
      act = ck.cmd "Telescope lsp_type_definitions",
      desc = "lsp definition type",
    },
    ["<leader>c"] = {
      name = "code",

      a = { act = vim.lsp.buf.code_action, desc = "lsp code action" },
      l = { act = vim.lsp.codelens.run, desc = "lsp run codelens" },
      r = { act = vim.lsp.buf.rename, desc = "lsp rename" },
      s = { act = vim.lsp.buf.signature_help, desc = "lsp signature help" },
    },

    ["<leader>d"] = {
      name = "diagnostics",

      b = { act = vim.diagnostic.setloclist, desc = "buffer diagnostics" },
      w = { act = vim.diagnostic.setqflist, desc = "workspace diagnostics" },
      t = {
        act = function()
          local current = vim.diagnostic.config()
          if current.virtual_lines == true then
            vim.diagnostic.config { virtual_lines = false, virtual_text = true }
          else
            vim.diagnostic.config { virtual_lines = true, virtual_text = false }
          end
        end,
        desc = "toggle mutliline diagnostics",
      },
    },

    ["<leader>s"] = {
      name = "lsp symbols",

      w = {
        act = ck.cmd "Telescope lsp_dynamic_workspace_symbols",
        desc = "lsp workspace symbols",
      },
      d = {
        act = ck.cmd "Telescope lsp_document_symbols",
        desc = "lsp document symbols",
      },
    },

    ["<C-s>"] = {
      act = ck.cmd "SymbolsOutline",
      desc = "toggle outline",

      when_extend = ck.ft "Outline",
    },
  },

  -- GIT
  ["<leader>g"] = {
    name = "git",

    b = { act = ck.cmd "Telescope git_branches", desc = "git branches" },
    c = { act = ck.cmd "Telescope git_commits", desc = "git commits" },
    n = { act = ck.cmd "Neogit", desc = "neogit" },
    s = { act = ck.cmd "Neotree git_status", desc = "git status" },
  },
  {
    when = ck.emitted "Gitsigns",

    function()
      local gs = require "gitsigns"

      return {
        ["<leader>h"] = {
          name = "hunk",

          s = {
            act = {
              n = gs.stage_hunk,
              v = function()
                gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
              end,
            },
            desc = "stage hunk",
          },
          r = {
            act = {
              n = gs.reset_hunk,
              v = function()
                gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
              end,
            },
            desc = "rest hunk",
          },
          S = { act = gs.stage_buffer, desc = "stage buffer" },
          u = { act = gs.undo_stage_hunk, desc = "unstage hunk" },
          p = { act = gs.preview_hunk, desc = "preview hunk" },
          b = {
            act = function()
              gs.blame_line { full = true }
            end,
            desc = "blame line",
          },
          d = { act = gs.diffthis, desc = "diff this" },
          D = {
            act = function()
              gs.diffthis "~"
            end,
            desc = "diff this",
          },
        },
      }
    end,
  },

  ["ih"] = {
    mode = { "o", "x" },
    act = ":<C-U>Gitsigns select_hunk<CR>",
  },

  -- FIND
  ["<C-n>"] = { act = utils.cmdfn "Neotree toggle", desc = "toggle neotree", mode = "n" },

  ["<leader>f"] = {
    name = "find",

    a = {
      act = ck.cmd "Telescope find_files follow=true no_ignore=true hidden=true",
      desc = "find all files",
    },
    f = { act = ck.cmd "Telescope find_files", desc = "find files" },
    h = { act = ck.cmd "Telescope help_tags", desc = "find help" },
    o = { act = ck.cmd "Telescope oldfiles only_cwd=true", desc = "find oldfiles" },
    r = { act = ck.cmd "Telescope resume", desc = "resume last search" },
    w = {
      act = {
        n = function()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        v = function()
          local selected_text = require("user.common.selection").get_visual_selection()
          require("telescope").extensions.live_grep_args.live_grep_args {
            default_text = selected_text,
          }
        end,
      },
      desc = "live grep",
    },
  },

  -- HASKELL
  {
    when = ck.ft { "haskell", "cabal" },

    ["<A-r>"] = {
      act = function()
        require("haskell-tools").repl.toggle()
      end,
      desc = "package GHCi",
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
        act = function()
          require("haskell-tools").repl.quit()
        end,
        desc = "quit GHCi",
      },
    },
  },
}

return M
