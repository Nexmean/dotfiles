local plugins = {}

plugins["NvChad/ui"] = {
  override_options = {
    statusline = {
      separator_style = {
        left = "",
        right = "█",
      },
    },
  },
}

plugins["kyazdani42/nvim-tree.lua"] = {
  override_options = {
    git = {
      enable = true,
      ignore = false,
    },
    renderer = {
      highlight_git = true,
    }
  }
}

plugins["nvim-telescope/telescope.nvim"] = {
  requires = {
     "nvim-telescope/telescope-live-grep-args.nvim",
     "nvim-telescope/telescope-ui-select.nvim",
     {"Nexmean/telescope_hoogle", branch = "cabal-hoogle"},
     {"nvim-telescope/telescope-fzf-native.nvim", run = "make"},
  },
  module = "telescope",
  override_options = function ()
    return require "custom.plugins.configs.telescope"
  end,
}

plugins["folke/which-key.nvim"] = {
  disable = false,
}

plugins["petertriho/nvim-scrollbar"] = {
  config = function ()
    require("scrollbar").setup {}
  end
}

plugins["folke/zen-mode.nvim"] = {
  cmd = "ZenMode",
  config = function()
     require("zen-mode").setup {}
  end,
}

plugins["kevinhwang91/nvim-bqf"] = { ft = "qf" }

plugins["j-hui/fidget.nvim"] = {
  after = "ui",
  config = function()
    require("fidget").setup {}
  end,
}

plugins["TimUntersberger/neogit"] = {
  requires = { "nvim-lua/plenary.nvim" },
  after = "diffview.nvim",
  cmd = "Neogit",
  module = "neogit",
  config = function()
    require("neogit").setup {
      disable_commit_confirmation = true,
      disable_context_highlighting = false,
      disable_insert_on_commit = false,
      integrations = {
        diffview = true,
      },
      signs = {
        section = { "", "" },
        item = { "", "" },
        hunk = { "", "" },
      },
    }
  end,
}

plugins["sindrets/diffview.nvim"] = {
  requires = {"nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons"},
  after = "plenary.nvim",
  module = "diffview",
  cmd = {"DiffviewOpen", "DiffviewFileHistory"},
  config = function()
     local options = require "custom.plugins.configs.diffview"
     require("diffview").setup(options)
  end,
}

plugins["kylechui/nvim-surround"] = {
  config = function()
    require("nvim-surround").setup {}
  end,
}

plugins["phaazon/hop.nvim"] = {
  branch = "v2",
  config = function()
    require("hop").setup {}
  end,
}

plugins["mhartington/formatter.nvim"] = {
  cmd = { "Format", "FormatWrite" },
  config = function()
    require("formatter").setup {
      logging = true,
      log_level = vim.log.levels.WARN,
      filetype = {
        haskell = {
          function()
             return {
                exe = "stylish-haskell",
                stdin = true,
             }
          end,
        },
        lua = {
          require("formatter.filetypes.lua").stylua,
        },
      },
    }
  end,
}

plugins["gpanders/editorconfig.nvim"] = {}

return plugins
