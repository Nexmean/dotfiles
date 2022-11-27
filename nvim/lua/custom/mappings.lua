local mappings = {}

local function toggle_mutliline_diagnostics()
  local current = vim.diagnostic.config()
  if current.virtual_lines == true then
    vim.diagnostic.config {virtual_lines = false, virtual_text = true}
  else
    vim.diagnostic.config {virtual_lines = true, virtual_text = false}
  end
end

mappings.disabled = {
  n = {
    ["<leader>h"] = "",
    ["<leader>v"] = "",
  },
}

mappings.general = {
  n = {
    ["<leader>z"] = { "<cmd> ZenMode <CR>", "zen mode" },
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
  },
}

mappings.lsp = {
  n = {
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

mappings.telescope = {
  n = {
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
  },
  v = {
    ["<leader>fw"] = {
      function()
        local selected_text = require("custom.utils.selection").get_visual_selection()
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

return mappings
