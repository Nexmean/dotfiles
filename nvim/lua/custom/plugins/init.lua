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
     {"Nexmean/telescope_hoogle", branch = "cabal-hoogle"},
     {"nvim-telescope/telescope-fzf-native.nvim", run = "make"},
  },
  opt = false,
  module = {"telescope", "telescope.actions"},
  override_options = function ()
    return require "custom.plugins.configs.telescope"
  end,
}

plugins["stevearc/dressing.nvim"] = {
  config = function ()
    return {
      select = {
        backend = {"telescope"},
        telescope = {
        },
      },
    }
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

plugins["TimUntersberger/neogit"] = {
  requires = { "nvim-lua/plenary.nvim" },
  after = "diffview.nvim",
  opt = false,
  -- cmd = "Neogit",
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
  opt = false,
  module = "diffview",
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
        cabal = {
          function()
            return {
              exe = "cabal-fmt",
              args = {"--no-tabular"},
              stdin = true,
            }
          end
        },
        lua = {
          require("formatter.filetypes.lua").stylua,
        },
      },
    }
  end,
}

plugins["gpanders/editorconfig.nvim"] = {}

plugins["MrcJkb/haskell-tools.nvim"] = {
  after = {
    "nvim-lspconfig",
    "plenary.nvim",
    "telescope.nvim",
  },
  module = "haskell-tools",
  ft = {"haskell", "cabal"},
  config = function()
    local ht = require "haskell-tools"
    local nvchad = require "plugins.configs.lspconfig"
    local def_opts = { noremap = true, silent = true, }
    ht.setup {
      hls = {
        -- See nvim-lspconfig's  suggested configuration for keymaps, etc.
        on_attach = function(client, bufnr)
          nvchad.on_attach(client, bufnr)
          local opts = vim.tbl_extend('keep', def_opts, { buffer = bufnr, })
          -- haskell-language-server relies heavily on codeLenses,
          -- so auto-refresh (see advanced configuration) is enabled by default
          -- vim.keymap.set('n', '<leader>ca', vim.lsp.codelens.run, opts)
          vim.keymap.set('n', '<leader>hs', ht.hoogle.hoogle_signature, opts)
          -- default_on_attach(client, bufnr)  -- if defined, see nvim-lspconfig
        end,
        settings = {
          haskell = {
            checkProject = false,
          },
        },
      },
      hoogle = {
        mode = "telescope-web",
      },
    }
  end
}

plugins["neovim/nvim-lspconfig"] = {
  config = function ()
    local nvchad = require "plugins.configs.lspconfig"
    local lspconfig = require "lspconfig"

    local servers = {"jsonls", "bashls", "csharp_ls"}

    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
        on_attach = function(client, bufnr)
          nvchad.on_attach(client, bufnr)
        end,
        capabilities = nvchad.capabilities,
      }
    end
  end
}

plugins["neovimhaskell/haskell-vim"] = {
  disable = true,
}

plugins["yamatsum/nvim-cursorline"] = {
  config = function ()
    require("nvim-cursorline").setup {
      cursorword = {
        enable = true,
        min_length = 3,
        hl = { underline = true },
      },
    }
  end
}

plugins["nvim-neotest/neotest"] = {
  requires = {
    "plenary.nvim", "add",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "MrcJkb/neotest-haskell",
  },
  config = function()
    require("neotest").setup {
      adapters = {
        require "neotest-haskell",
      },
    }
  end
}

plugins["simrat39/symbols-outline.nvim"] = {
  after = "nvim-lspconfig",
  config = function()
    require("symbols-outline").setup()
  end,
}

plugins["https://git.sr.ht/~whynothugo/lsp_lines.nvim"] = {
  config = function()
    require("lsp_lines").setup()
    vim.diagnostic.config({virtual_lines = false})
  end,
}

plugins["utilyre/barbecue.nvim"] = {
  requires = {
    "neovim/nvim-lspconfig",
    "smiteshp/nvim-navic",
    "kyazdani42/nvim-web-devicons", -- optional
  },
  config = function()
    require("barbecue").setup()
  end,
}

plugins["max397574/colortils.nvim"] = {
  cmd = "Colortils",
  config = function()
    require("colortils").setup()
  end,
}

return plugins
