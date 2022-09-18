local mappings = {}

mappings.general = {
  n = {
    ["<leader>z"] = {"<cmd> ZenMode <CR>", "zen mode"},
    ["<leader>tx"] = {"<cmd> tabclose <CR>", "close tab"},
    ["<leader>tn"] = {"<cmd> tabnew <CR>", "new tab"},

    ["g1"] = { "<cmd> 1tabnext <CR>", "tab 1" },
    ["g2"] = { "<cmd> 2tabnext <CR>", "tab 2" },
    ["g3"] = { "<cmd> 3tabnext <CR>", "tab 3" },
    ["g4"] = { "<cmd> 4tabnext <CR>", "tab 4" },
    ["g5"] = { "<cmd> 5tabnext <CR>", "tab 5" },
    ["g6"] = { "<cmd> 6tabnext <CR>", "tab 6" },
    ["g7"] = { "<cmd> 7tabnext <CR>", "tab 7" },
    ["g8"] = { "<cmd> 8tabnext <CR>", "tab 8" },
    ["g9"] = { "<cmd> 9tabnext <CR>", "tab 9" },
  }
}

mappings.lsp = {
  n = {
    ["<A-k>"] = {
      function() vim.diagnostic.open_float() end,
      "floating diagnostic",
    },
    ["gi"] = { "<cmd> Telescope lsp_implementations <CR>", "lsp implementation" },
    ["gr"] = { "<cmd> Telescope lsp_references <CR>", "lsp references" },
    ["gd"] = { "<cmd> Telescope lsp_definitions <CR>", "lsp definition" },
    ["<leader>ds"] = { "<cmd> Telescope lsp_document_symbols <CR>", "document symbols" },
    ["<leader>ws"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "workspace symbols" },
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
  },
  v = {
    ["<leader>fw"] = {
      function()
        local selected_text = require("custom.utils.selection").get_visual_selection()
        require("telescope").extensions.live_grep_args.live_grep_args { default_text = selected_text }
      end,
      "live grep",
    },
  }
}

local function hop(method)
  return function()
    require("hop")[method]()
  end
end

mappings.hop = {
  v = {
    ["ga"] = {hop "hint_anywhere", "hop anywhere"},
    ["gl"] = {hop "hint_lines", "hop line"},
    ["gw"] = {hop "hint_words", "hop word"},
  },
  n = {
    ["ga"] = {hop "hint_anywhere", "hop anywhere"},
    ["gl"] = {hop "hint_lines", "hop line"},
    ["gw"] = {hop "hint_words", "hop word"},
  },
}

mappings.git = {
  n = {
    ["<leader>gn"] = {"<cmd>Neogit <CR> ", "neogit"},
  },
}

return mappings
