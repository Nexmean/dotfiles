local function conf(config_name)
  return require(string.format("user.plugins.%s", config_name))
end

vim.g.netrw_liststyle = 1
vim.g.netrw_sort_by = "exten"
vim.g.netrw_bufsettings = "noma nomod nonu nowrap ro nornu"

vim.g.markdown_fenced_languages = {
  "html",
  "python",
  "sh",
  "bash=sh",
  "dosini",
  "ini=dosini",
  "lua",
  "cpp",
  "c++=cpp",
  "javascript",
  "java",
  "vim",
}

local html_like_ft = {
  "html", "javascript", "typescript", "javascriptreact", "typescriptreact",
  "svelte", "vue", "tsx", "jsx", "rescript",
  "xml", "php",
  "markdown", "glimmer","handlebars","hbs"
}

local plugins = {
  { "williamboman/mason.nvim",
    config = function ()
      require("mason").setup()
    end
  },

  -- SYNTAX
  { "MTDL9/vim-log-highlighting" },
  { "teal-language/vim-teal",
    ft = "teal"
  },
  { "chrisbra/csv.vim",
    ft = "csv"
  },
  { "fladson/vim-kitty",
    ft = "kitty",
  },
  { "joelbeedle/pseudo-syntax" },
  { "alisdair/vim-armasm" },
  { "vmchale/dhall-vim",
    ft = "dhall",
  },


  -- BEHAVIOUR
  {
    "antoinemadec/FixCursorHold.nvim",
    init = function()
      vim.g.cursorhold_updatetime = 250
    end
  },

  {
    's1n7ax/nvim-window-picker',
    version = 'v1.*',
    config = conf("window-picker"),
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "s1n7ax/nvim-window-picker",
    },
    cmd = "Neotree",
    config = conf("neo-tree"),
  },
  { "mhartington/formatter.nvim",
    cmd = { "Format", "FormatLock", "FormatWrite", "FormatWriteLock" },
    config = conf("formatter")
  },
  {
    "phaazon/hop.nvim",
    branch = "v2",
    config = function()
      require("hop").setup {}
    end,
  },
  {
    "utilyre/barbecue.nvim",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "smiteshp/nvim-navic" },
      { "nvim-tree/nvim-web-devicons" },
    },
    config = conf("barbecue"),
  },

  {
    "Darazaki/indent-o-matic",
    commit = "bf37c6e",
    config = function()
      require("indent-o-matic").setup({
        -- Number of lines without indentation before giving up (use -1 for infinite)
        max_lines = 2048,
        -- Space indentations that should be detected
        standard_widths = { 2, 3, 4, 8 },
        -- Skip multi-line comments and strings (more accurate detection but less performant)
        skip_multiline = true,
      })
    end,
  },
  { "nvim-lua/popup.nvim" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons", config = conf("nvim-web-devicons") },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = conf("treesitter"),
  },
  { "nvim-treesitter/playground", dependencies = "nvim-treesitter/nvim-treesitter" },
  { "sindrets/lua-dev.nvim" },
  { "neovim/nvim-lspconfig" },
  { "jose-elias-alvarez/null-ls.nvim", config = conf("null-ls") },
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup({
          hint_enable = false,
          hint_prefix = "● ",
          max_width = 80,
          max_height = 12,
          handler_opts = {
            border = "single"
          }
        })
    end
  },
  { "gpanders/editorconfig.nvim" },
  { "anuvyklack/pretty-fold.nvim", config = conf("pretty-fold") },
  { "mfussenegger/nvim-jdtls" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
      { "L3MON4D3/LuaSnip", version = "v1.*",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function ()
          require("luasnip.loaders.from_vscode").lazy_load()
        end
      },
      { "hrsh7th/cmp-cmdline" },
      { "f3fora/cmp-spell" },
      { "petertriho/cmp-git" },
      { "rafamadriz/friendly-snippets" },
      { "windwp/nvim-autopairs" }
    },
    event = { "InsertEnter", "CmdlineEnter" },
    config = conf("nvim-cmp"),
  },
  {
    url = "https://gitlab.com/yorickpeterse/nvim-pqf.git",
    ft = "qf",
    config = function()
      require("pqf").setup({
        signs = {
          error = "",
          warning = "",
          info = "",
          hint = "",
        }
      })
    end,
  },
  { "kevinhwang91/nvim-bqf", ft = "qf", config = conf("nvim-bqf") },
  { "windwp/nvim-autopairs", config = conf("nvim-autopairs") },
  { "sindrets/nvim-colorizer.lua", config = conf("nvim-colorizer") },
  { "numToStr/Comment.nvim",
    config = function ()
      require("Comment").setup()
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-media-files.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      { "nvim-tree/nvim-web-devicons" }
    },
    cmd = { "Telescope" },
    event = { "LspAttach" },
    config = conf("telescope"),
  },

  {
    "LukasPietzschmann/telescope-tabs",
    lazy = true,
    dependencies = "nvim-telescope/telescope.nvim",
    config = function ()
      require("telescope-tabs").setup {
        show_preview = false
      }
    end
  },

  {
    "mattn/emmet-vim",
    ft = html_like_ft,
    init = function ()
      vim.g.user_emmet_leader_key = "<C-Z>"
    end,
  },
  { "tpope/vim-abolish" },
  { "windwp/nvim-ts-autotag",
    ft = html_like_ft,
    config = function ()
      require("nvim-ts-autotag").setup()
    end
  },
  { "Rasukarusan/nvim-block-paste" },
  { "godlygeek/tabular",
    cmd = "Tabularize"
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup()
    end
  },
  { "tweekmonster/startuptime.vim", cmd = { "StartupTime" } },
  { "RRethy/vim-illuminate", config = conf("vim-illuminate") },
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
      vim.notify.setup({
        top_down = false,
      })
    end,
  },
  {
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function ()
      require("lsp_lines").setup()
      vim.diagnostic.config({virtual_lines = false})
    end
  },

  -- MISC
  { "feline-nvim/feline.nvim", config = conf("feline") },
  { "lewis6991/gitsigns.nvim", config = conf("gitsigns") },
  { "lukas-reineke/indent-blankline.nvim", init = conf("indent-blankline") },
  {
    "folke/lsp-trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble", "TroubleToggle" },
    config = conf("lsp-trouble"),
  },
  { "sindrets/diffview.nvim", config = conf("diffview") },
  { "sindrets/winshift.nvim", config = conf("winshift") },
  {
    "TimUntersberger/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    cmd = { "Neogit" },
    config = conf("neogit"),
  },
  {
    "simrat39/symbols-outline.nvim",
    init = conf("symbols-outline"),
    cmd = { "SymbolsOutline", "SymbolsOutlineClose", "SymbolsOutlineOpen" },
  },
  {
    "p00f/nvim-ts-rainbow",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf("nvim-ts-rainbow")
  },
  {
    "tpope/vim-fugitive",
    lazy = false,
    dependencies = { "tpope/vim-rhubarb" },
    config = conf("fugitive"),
  },
  { "goolord/alpha-nvim", config = conf("alpha") },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = { "markdown" },
    init = function ()
      vim.api.nvim_exec([[
        function! MkdpOpenInNewWindow(url)
          if executable("qutebrowser")
            call jobstart([ "qutebrowser", "--target", "window", a:url ])
          elseif executable("chromium")
            call jobstart([ "chromium", "--app=" . a:url ])
          elseif executable("firefox")
            call jobstart([ "firefox", "--new-window", a:url ])
          else
            echoerr '[MKDP] No suitable browser!'
          endif
        endfunction
        ]], false)
      vim.g.mkdp_browserfunc = "MkdpOpenInNewWindow"
    end,
  },
  { "honza/vim-snippets" },
  {
    'MrcJkb/haskell-tools.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    ft = "haskell",
    config = conf("haskell-tools")
  },
  {
    "j-hui/fidget.nvim",
    config = function ()
      require("fidget").setup()
    end
  },

  -- THEMES
  { "rktjmp/lush.nvim" },
  { "arzg/vim-colors-xcode" },
  { "sainnhe/gruvbox-material" },
  { "gruvbox-community/gruvbox" },
  { "folke/tokyonight.nvim" },
  { "sindrets/material.nvim" },
  { "sindrets/rose-pine-neovim", name = "rose-pine" },
  { "mcchrish/zenbones.nvim", dependencies = "rktjmp/lush.nvim" },
  { "sainnhe/everforest" },
  { "Cybolic/palenight.vim" },
  { "olimorris/onedarkpro.nvim", enabled = false, branch = "main" }, -- loads too slow
  { "NTBBloodbath/doom-one.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "sindrets/dracula-vim", name = "dracula" },
  { "projekt0n/github-nvim-theme" },
  { "rebelot/kanagawa.nvim" },
  { "sindrets/oxocarbon-lua.nvim" },
  { "nyoom-engineering/oxocarbon.nvim" },
  { "EdenEast/nightfox.nvim" },
  { "kvrohit/mellow.nvim" },
}
local opts = {}

require("lazy").setup(plugins, opts)
