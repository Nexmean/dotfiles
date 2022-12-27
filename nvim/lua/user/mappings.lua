local utils = require("user.common.utils")
-- n, v, i, t = mode names
local mappings = {}

local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function toggle_mutliline_diagnostics()
  local current = vim.diagnostic.config()
  if current.virtual_lines == true then
    vim.diagnostic.config {virtual_lines = false, virtual_text = true}
  else
    vim.diagnostic.config {virtual_lines = true, virtual_text = false}
  end
end

mappings.general = {
  i = {
    ["<C-a>"] = { "<Home>", "beginning of line" },
    ["<C-e>"] = { "<End>", "end of line" },
    ["<C-f>"] = { "<Right>", "move forward" },
    ["<C-b>"] = { "<Left>", "move back" },
    ["<C-d>"] = { "<Delete>", "delete next character" },

    ["<A-i>"] = { utils.cmdfn "TermToggle", "toggle terminal" },
  },

  n = {
    ["<ESC>"] = { utils.cmdfn "noh", "no highlight" },

    -- switch between windows
    ["<C-h>"] = { "<C-w>h", "window left" },
    ["<C-l>"] = { "<C-w>l", "window right" },
    ["<C-j>"] = { "<C-w>j", "window down" },
    ["<C-k>"] = { "<C-w>k", "window up" },

    -- line numbers
    ["<leader>n"] = { utils.cmdfn "set nu!", "toggle line number" },
    ["<leader>rn"] = { utils.cmdfn "set rnu!", "toggle relative number" },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },

    -- new buffer
    ["<leader>b"] = { utils.cmdfn "enew", "new buffer" },
    ["<leader>tx"] = { utils.cmdfn "tabclose", "close tab" },
    ["<leader>tn"] = { utils.cmdfn "tabnew", "new tab" },
    ["<leader>dt"] = { toggle_mutliline_diagnostics, "toggle multiline diagnostics"},

    ["g1"] = { utils.cmdfn "1tabnext", "tab 1" },
    ["g2"] = { utils.cmdfn "2tabnext", "tab 2" },
    ["g3"] = { utils.cmdfn "3tabnext", "tab 3" },
    ["g4"] = { utils.cmdfn "4tabnext", "tab 4" },
    ["g5"] = { utils.cmdfn "5tabnext", "tab 5" },
    ["g6"] = { utils.cmdfn "6tabnext", "tab 6" },
    ["g7"] = { utils.cmdfn "7tabnext", "tab 7" },
    ["g8"] = { utils.cmdfn "8tabnext", "tab 8" },
    ["g9"] = { utils.cmdfn "9tabnext", "tab 9" },

    ["<A-i>"] = { utils.cmdfn "TermToggle", "toggle terminal" },

    ["~"] = { utils.cmdfn "buffer #", "recent buffer" },
    ["<C-w><C-w>"] = { utils.cmdfn "PickAny", "pick buffer" }
  },

  t = {
    ["<C-a>"] = { "<Home>", "beginning of line" },
    ["<C-e>"] = { "<End>", "end of line" },
    ["<C-f>"] = { "<Right>", "move forward" },
    ["<C-b>"] = { "<Left>", "move back" },
    ["<C-x>"] = { termcodes "<C-\\><C-N>", "escape terminal mode" },
    ["<A-i>"] = { utils.cmdfn "TermToggle", "toggle terminal" },
  },

  c = {
    ["<C-a>"] = { "<Home>", "beginning of line" },
    ["<C-e>"] = { "<End>", "end of line" },
    ["<C-f>"] = { "<Right>", "move forward" },
    ["<C-b>"] = { "<Left>", "move back" },
    ["<C-d>"] = { "<Delete>", "delete next character" },
  },

  v = {
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
    ["<A-i>"] = { utils.cmdfn "TermToggle", "toggle terminal" },
    ["<C-w><C-w>"] = { utils.cmdfn "PickAny", "pick buffer" }
  },

  x = {
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', opts = { silent = true } },
    ["<A-i>"] = { utils.cmdfn "TermToggle", "toggle terminal" },
  },
}

mappings.lspconfig = {
  plugin = true,

  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

  n = {
    ["gD"] = {
      function()
        vim.lsp.buf.declaration()
      end,
      "lsp declaration",
    },
    ["K"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "lsp hover",
    },

    ["<leader>ls"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "lsp signature_help",
    },

    ["<leader>D"] = {
      function()
        vim.lsp.buf.type_definition()
      end,
      "lsp definition type",
    },

    ["<leader>ra"] = {
      function()
        require("nvchad_ui.renamer").open()
      end,
      "lsp rename",
    },

    ["<leader>ca"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "lsp code_action",
    },

    ["<leader>f"] = {
      function()
        vim.diagnostic.open_float()
      end,
      "floating diagnostic",
    },

    ["[d"] = {
      function()
        vim.diagnostic.goto_prev()
      end,
      "goto prev",
    },

    ["d]"] = {
      function()
        vim.diagnostic.goto_next()
      end,
      "goto_next",
    },

    ["<leader>q"] = {
      function()
        vim.diagnostic.setloclist()
      end,
      "diagnostic setloclist",
    },

    ["<leader>fm"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      "lsp formatting",
    },

    ["<leader>wa"] = {
      function()
        vim.lsp.buf.add_workspace_folder()
      end,
      "add workspace folder",
    },

    ["<leader>wr"] = {
      function()
        vim.lsp.buf.remove_workspace_folder()
      end,
      "remove workspace folder",
    },

    ["<leader>wl"] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      "list workspace folders",
    },

    ["<A-k>"] = {
      function()
        vim.diagnostic.open_float()
      end,
      "floating diagnostic",
    },
    ["gi"] = { utils.cmdfn "Telescope lsp_implementations", "lsp implementation" },
    ["gr"] = { utils.cmdfn "Telescope lsp_references", "lsp references" },
    ["gd"] = { utils.cmdfn "Telescope lsp_definitions", "lsp definition" },
    ["<leader>ds"] = { utils.cmdfn "Telescope lsp_document_symbols", "document symbols" },
    ["<leader>ws"] = { utils.cmdfn "Telescope lsp_dynamic_workspace_symbols", "workspace symbols" },
    ["<C-s>"] = { utils.cmdfn "SymbolsOutline", "toggle outline" }
  },
}

mappings.neotree = {
  n = {
    -- toggle
    ["<C-n>"] = { utils.cmdfn "Neotree toggle", "toggle neotree" },

    -- focus
    ["<leader>e"] = { utils.cmdfn "Neotree", "focus neotree" },
  },
}

mappings.telescope = {
  n = {
    -- find
    ["<leader>ff"] = { utils.cmdfn "Telescope find_files", "find files" },
    ["<leader>fa"] = { utils.cmdfn "Telescope find_files follow=true no_ignore=true hidden=true", "find all" },
    ["<leader>fb"] = { utils.cmdfn "Telescope buffers", "find buffers" },
    ["<leader>fh"] = { utils.cmdfn "Telescope help_tags", "help page" },
    ["<leader>fo"] = { utils.cmdfn "Telescope oldfiles only_cwd=true", "find oldfiles" },
    ["<leader>tk"] = { utils.cmdfn "Telescope keymaps", "show keys" },

    -- git
    ["<leader>cm"] = { utils.cmdfn "Telescope git_commits", "git commits" },
    ["<leader>gt"] = { utils.cmdfn "Telescope git_status", "git status" },

    -- pick a hidden term
    ["<leader>pt"] = { utils.cmdfn "Telescope terms", "pick hidden term" },
    ["gj"] = { utils.cmdfn "Telescope buffers sort_lastused=true sort_mru=true", "find buffers" },
    ["<leader>fw"] = {
      function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end,
      "   live grep",
    },
    ["<leader>fr"] = { utils.cmdfn "Telescope resume", "repeat recent search" },
    ["<leader>fp"] = { utils.cmdfn "Telescope pickers", "recent searches" },
    ["<leader>gb"] = { utils.cmdfn "Telescope git_branches", "git branches" },
    ["<A-p>"] = { utils.cmdfn "Telescope commands", "command pallete" },
    ["<leader>tt"] = { utils.cmdfn "Telescope telescope-tabs list_tabs", "list tabs" }
  },

  v = {
    ["<leader>fw"] = {
      function()
        local selected_text = require("user.common.selection").get_visual_selection()
        require("telescope").extensions.live_grep_args.live_grep_args { default_text = selected_text }
      end,
      "live grep",
    },
    ["<A-p>"] = { utils.cmdfn "Telescope commands", "command pallete" },
  },

  i = {
    ["<A-p>"] = { utils.cmdfn "Telescope commands", "command pallete" },
  },
}

mappings.whichkey = {
  n = {
    ["<leader>wK"] = {
      utils.cmdfn "WhichKey",
      "which-key all keymaps",
    },
    ["<leader>wk"] = {
      function()
        local input = vim.fn.input "WhichKey: "
        vim.cmd("WhichKey " .. input)
      end,
      "which-key query lookup",
    },
  },
}

mappings.blankline = {
  plugin = true,

  n = {
    ["<leader>cc"] = {
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

      "Jump to current_context",
    },
  },
}

mappings.lsp = {
  n = {
  },
}

local function hop(method)
  return function()
    require("hop")[method]()
  end
end

mappings.hop = {
  v = {
    ["ga"] = { hop "hint_anywhere", "hop anywhere" },
    ["gl"] = { hop "hint_lines", "hop line" },
    ["gw"] = { hop "hint_words", "hop word" },
  },
  n = {
    ["ga"] = { hop "hint_anywhere", "hop anywhere" },
    ["gl"] = { hop "hint_lines", "hop line" },
    ["gw"] = { hop "hint_words", "hop word" },
  },
}

mappings.git = {
  n = {
    ["<leader>gn"] = { utils.cmdfn "Neogit", "neogit" },
  },
}

mappings.haskell = {
  n = {
    -- Toggle a GHCi repl for the current package
    ["<A-r>"] = {
      function ()
        require("haskell-tools").repl.toggle()
      end,
      "toggle GHCi"
    },
    -- Toggle a GHCi repl for the current buffer
    ["<leader>rf"] = {
      function()
        require("haskell-tools").repl.toggle(vim.api.nvim_buf_get_name(0))
      end,
      "toggle GHCi for file"
    },
    ["<leader>rq"] = {
      function ()
        require("haskell-tools").repl.quit()
      end,
      "quit GHCi"
    },
  },
}

local merge_tb = vim.tbl_deep_extend

mappings.load = function(section, mapping_opt)
  local function set_section_map(section_values)
    if section_values.plugin then
      return
    end
    section_values.plugin = nil

    for mode, mode_values in pairs(section_values) do
      local default_opts = merge_tb("force", { mode = mode }, mapping_opt or {})
      for keybind, mapping_info in pairs(mode_values) do
        -- merge default + user opts
        local opts = merge_tb("force", default_opts, mapping_info.opts or {})

        mapping_info.opts, opts.mode = nil, nil
        opts.desc = mapping_info[2]

        vim.keymap.set(mode, keybind, mapping_info[1], opts)
      end
    end
  end

  local mappings_ = mappings

  if type(section) == "string" then
    mappings[section]["plugin"] = nil
    mappings_ = { mappings[section] }
  end

  for key, sect in pairs(mappings_) do
    if key ~= "load" then
      set_section_map(sect)
    end
  end
end

return mappings
