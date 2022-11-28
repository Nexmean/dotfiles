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
    -- go to  beginning and end
    ["<C-b>"] = { "<ESC>^i", "beginning of line" },
    ["<C-e>"] = { "<End>", "end of line" },

    -- navigate within insert mode
    ["<C-h>"] = { "<Left>", "move left" },
    ["<C-l>"] = { "<Right>", "move right" },
    ["<C-j>"] = { "<Down>", "move down" },
    ["<C-k>"] = { "<Up>", "move up" },
    ["<A-i>"] = { "<cmd>TermToggle<CR>", "toggle terminal" },
  },

  n = {
    ["<ESC>"] = { "<cmd> noh <CR>", "no highlight" },

    -- switch between windows
    ["<C-h>"] = { "<C-w>h", "window left" },
    ["<C-l>"] = { "<C-w>l", "window right" },
    ["<C-j>"] = { "<C-w>j", "window down" },
    ["<C-k>"] = { "<C-w>k", "window up" },

    -- save
    ["<C-s>"] = { "<cmd> w <CR>", "save file" },

    -- Copy all
    ["<C-c>"] = { "<cmd> %y+ <CR>", "copy whole file" },

    -- line numbers
    ["<leader>n"] = { "<cmd> set nu! <CR>", "toggle line number" },
    ["<leader>rn"] = { "<cmd> set rnu! <CR>", "toggle relative number" },

    -- update nvchad
    ["<leader>uu"] = { "<cmd> :NvChadUpdate <CR>", "update nvchad" },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },

    -- new buffer
    ["<leader>b"] = { "<cmd> enew <CR>", "new buffer" },
    ["<leader>tx"] = { "<cmd> tabclose <CR>", "close tab" },
    ["<leader>tn"] = { "<cmd> tabnew <CR>", "new tab" },
    ["<leader>dt"] = { toggle_mutliline_diagnostics, "toggle multiline diagnostics"},

    ["g1"] = { "<cmd> 1tabnext <CR>", "tab 1" },
    ["g2"] = { "<cmd> 2tabnext <CR>", "tab 2" },
    ["g3"] = { "<cmd> 3tabnext <CR>", "tab 3" },
    ["g4"] = { "<cmd> 4tabnext <CR>", "tab 4" },
    ["g5"] = { "<cmd> 5tabnext <CR>", "tab 5" },
    ["g6"] = { "<cmd> 6tabnext <CR>", "tab 6" },
    ["g7"] = { "<cmd> 7tabnext <CR>", "tab 7" },
    ["g8"] = { "<cmd> 8tabnext <CR>", "tab 8" },
    ["g9"] = { "<cmd> 9tabnext <CR>", "tab 9" },

    ["<A-i>"] = { "<cmd>TermToggle<CR>", "toggle terminal" },

    ["~"] = { "<Cmd>buffer #<CR>", "recent buffer" },
  },

  t = {
    ["<C-x>"] = { termcodes "<C-\\><C-N>", "escape terminal mode" },
    ["<A-i>"] = { "<cmd>TermToggle<CR>", "toggle terminal" },
  },

  v = {
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
    ["<A-i>"] = { "<cmd>TermToggle<CR>", "toggle terminal" },
  },

  x = {
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', opts = { expr = true } },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', opts = { silent = true } },
    ["<A-i>"] = { "<cmd>TermToggle<CR>", "toggle terminal" },
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
    ["gi"] = { "<cmd> Telescope lsp_implementations <CR>", "lsp implementation" },
    ["gr"] = { "<cmd> Telescope lsp_references <CR>", "lsp references" },
    ["gd"] = { "<cmd> Telescope lsp_definitions <CR>", "lsp definition" },
    ["<leader>ds"] = { "<cmd> Telescope lsp_document_symbols <CR>", "document symbols" },
    ["<leader>ws"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "workspace symbols" },
    ["<C-s>"] = { "<cmd>SymbolsOutline<CR>", "toggle outline" }
  },
}

mappings.neotree = {
  n = {
    -- toggle
    ["<C-n>"] = { "<cmd> Neotree toggle <CR>", "toggle neotree" },

    -- focus
    ["<leader>e"] = { "<cmd> Neotree <CR>", "focus neotree" },
  },
}

mappings.telescope = {
  n = {
    -- find
    ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "find files" },
    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "find all" },
    ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "find buffers" },
    ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "help page" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles only_cwd=true<CR>", "find oldfiles" },
    ["<leader>tk"] = { "<cmd> Telescope keymaps <CR>", "show keys" },

    -- git
    ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "git commits" },
    ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "git status" },

    -- pick a hidden term
    ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "pick hidden term" },
    ["gj"] = { "<cmd>Telescope buffers sort_lastused=true sort_mru=true <CR>", "find buffers" },
    ["<leader>fw"] = {
      function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end,
      "   live grep",
    },
    ["<leader>fr"] = { "<cmd>Telescope resume<CR>", "repeat recent search" },
    ["<leader>fp"] = { "<cmd>Telescope pickers<CR>", "recent searches" },
    ["<leader>gb"] = { "<cmd>Telescope git_branches<CR>", "git branches" },
    ["<A-p>"] = { "<cmd>Telescope commands<CR>", "command pallete" },
    ["<leader>tt"] = { "<cmd>Telescope telescope-tabs list_tabs<CR>", "list tabs" }
  },

  v = {
    ["<leader>fw"] = {
      function()
        local selected_text = require("user.common.selection").get_visual_selection()
        require("telescope").extensions.live_grep_args.live_grep_args { default_text = selected_text }
      end,
      "live grep",
    },
    ["<A-p>"] = { "<cmd>Telescope commands<CR>", "command pallete" },
  },

  i = {
    ["<A-p>"] = { "<cmd>Telescope commands<CR>", "command pallete" },
  },
}

mappings.whichkey = {
  n = {
    ["<leader>wK"] = {
      function()
        vim.cmd "WhichKey"
      end,
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
    ["<leader>gn"] = { "<cmd>Neogit <CR> ", "neogit" },
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
