vim.cmd("packadd packer.nvim")

local function conf(config_name)
  return require(string.format("user.plugins.%s", config_name))
end

local function wrap_local(spec)
  local name

  if type(spec) ~= "table" then
    spec = { spec }
  end

  ---@cast spec table
  if spec.as then
    name = spec.as
  else
    name = spec[1]:match(".*/(.*)")
    name = name:gsub("%.git$", "")
  end

  local local_path = spec.local_path
    or vim.env.PACKER_LOCAL_PATH
    or (vim.env.HOME .. "/Documents/dev/nvim/plugins")
  local path = local_path .. "/" .. name
  if vim.fn.isdirectory(path) == 0 then
    path = spec[1]
  end

  spec[1] = path

  return spec
end

---Use local development version if it exists.
---NOTE: Remember to run `:PackerClean :PackerInstall` to update symlinks.
---@param spec table|string
local function use_local(spec)
  local use = require("packer").use
  use(wrap_local(spec))
end

return require("packer").startup({
  ---@diagnostic disable-next-line: unused-local
  function (use, use_rocks)

    -- vim.g.did_load_filetypes = 1
    -- vim.g.loaded_netrwPlugin = 1
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

    -- vim.cmd([[runtime! ftdetect/*.vim]])
    -- vim.cmd([[runtime! ftdetect/*.lua]])

    use "wbthomason/packer.nvim"

    use "lewis6991/impatient.nvim"

    use {
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup()
      end
    }

    -- SYNTAX
    use { "MTDL9/vim-log-highlighting" }
    use { "teal-language/vim-teal",
      ft = "teal"
    }
    use { "chrisbra/csv.vim",
      ft = "csv"
    }
    use { "fladson/vim-kitty",
      ft = "kitty",
    }
    use { "joelbeedle/pseudo-syntax" }
    use { "alisdair/vim-armasm" }
    use { "vmchale/dhall-vim",
      ft = "dhall",
    }

    -- BEHAVIOUR
    use {
      "antoinemadec/FixCursorHold.nvim",
      setup = function()
        vim.g.cursorhold_updatetime = 250
      end
    }

    use {
      's1n7ax/nvim-window-picker',
      tag = 'v1.*',
      module = "window-picker",
      config = conf("window-picker"),
    }

    use {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        "Nexmean/nvim-window-picker",
      },
      cmd = "Neotree",
      config = conf("neo-tree"),
    }
    use { "mhartington/formatter.nvim",
      cmd = { "Format", "FormatLock", "FormatWrite", "FormatWriteLock" },
      config = conf("formatter")
    }
    use {
      "phaazon/hop.nvim",
      branch = "v2",
      config = function()
        require("hop").setup {}
      end,
    }
    use {
      "utilyre/barbecue.nvim",
      requires = {
        "neovim/nvim-lspconfig",
        "smiteshp/nvim-navic",
        "kyazdani42/nvim-web-devicons", -- optional
      },
      config = conf("barbecue"),
    }

    use {
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
    }
    use { "nvim-lua/popup.nvim" }
    use { "nvim-lua/plenary.nvim" }
    use { "kyazdani42/nvim-web-devicons", config = conf("nvim-web-devicons") }
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = conf("treesitter"),
    }
    use { "nvim-treesitter/playground", requires = "nvim-treesitter/nvim-treesitter" }
    use_local { "sindrets/lua-dev.nvim" }
    use { "neovim/nvim-lspconfig" }
    use { "jose-elias-alvarez/null-ls.nvim", config = conf("null-ls") }
    use {
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
    }
    use { "gpanders/editorconfig.nvim" }
    use { "anuvyklack/pretty-fold.nvim", config = conf("pretty-fold") }
    use { "mfussenegger/nvim-jdtls" }
    use {
      "hrsh7th/nvim-cmp",
      requires = {
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-vsnip", wants = "friendly-snippets" },
        { "hrsh7th/cmp-cmdline" },
        { "f3fora/cmp-spell" },
        { "rafamadriz/friendly-snippets" },
        { "petertriho/cmp-git" },
      },
      after = { "nvim-autopairs", "friendly-snippets" },
      config = conf("nvim-cmp"),
    }
    use {
      "https://gitlab.com/yorickpeterse/nvim-pqf.git",
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
    }
    use { "kevinhwang91/nvim-bqf", ft = "qf", config = conf("nvim-bqf") }
    use { "windwp/nvim-autopairs", config = conf("nvim-autopairs") }
    use { "sindrets/nvim-colorizer.lua", config = conf("nvim-colorizer") }
    use {
      "hrsh7th/vim-vsnip",
      setup = function()
        vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
      end,
    }
    use { "hrsh7th/vim-vsnip-integ" }
    use { "numToStr/Comment.nvim",
      config = function ()
        require("Comment").setup()
      end
    }
    use {
      "nvim-telescope/telescope.nvim",
      config = conf("telescope"),
      after = {"nvim-web-devicons", "telescope-live-grep-args.nvim"}
    }
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    use { "nvim-telescope/telescope-media-files.nvim" }
    use { "nvim-telescope/telescope-ui-select.nvim" }
    use { "nvim-telescope/telescope-live-grep-args.nvim" }
    use {
      "LukasPietzschmann/telescope-tabs",
      after = "telescope.nvim",
      config = function ()
        require("telescope-tabs").setup {
          show_preview = false
        }
      end
    }

    use {
      "mattn/emmet-vim",
      setup = function ()
        vim.g.user_emmet_leader_key = "<C-Z>"
      end,
    }
    use { "tpope/vim-abolish" }
    use { "windwp/nvim-ts-autotag",
      ft = {
        'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
        'svelte', 'vue', 'tsx', 'jsx', 'rescript',
        'xml', 'php',
        'markdown', 'glimmer','handlebars','hbs'
      },
      config = function ()
        require("nvim-ts-autotag").setup()
      end
    }
    use { "Rasukarusan/nvim-block-paste" }
    use { "godlygeek/tabular" }
    use {
      "kylechui/nvim-surround",
      tag = "*",
      config = function()
        require("nvim-surround").setup {}
      end
    }
    use { "tweekmonster/startuptime.vim", cmd = { "StartupTime" } }
    use { "RRethy/vim-illuminate", config = conf("vim-illuminate") }
    use {
      "rcarriga/nvim-notify",
      config = function()
        vim.notify = require("notify")
        vim.notify.setup({
          top_down = false,
        })
      end,
    }
    use {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function ()
        require("lsp_lines").setup()
        vim.diagnostic.config({virtual_lines = false})
      end
    }

    -- MISC
    use { "feline-nvim/feline.nvim", config = conf("feline") }
    use { "lewis6991/gitsigns.nvim", config = conf("gitsigns") }
    use_local { "lukas-reineke/indent-blankline.nvim", setup = conf("indent-blankline") }
    use {
      "folke/lsp-trouble.nvim",
      cmd = { "Trouble", "TroubleToggle" },
      config = conf("lsp-trouble"), after = "nvim-web-devicons",
    }
    use_local { "sindrets/diffview.nvim", config = conf("diffview") }
    use_local { "sindrets/winshift.nvim", config = conf("winshift") }
    use_local {
      "TimUntersberger/neogit",
      cmd = { "Neogit" },
      config = conf("neogit"),
      requires = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    }
    use {
      "simrat39/symbols-outline.nvim",
      setup = conf("symbols-outline"),
      cmd = { "SymbolsOutline", "SymbolsOutlineClose", "SymbolsOutlineOpen" },
    }
    use {
      "p00f/nvim-ts-rainbow",
      requires = { "nvim-treesitter/nvim-treesitter" },
      config = conf("nvim-ts-rainbow")
    }
    use {
      "tpope/vim-fugitive",
      requires = { "tpope/vim-rhubarb" },
      config = conf("fugitive"),
    }
    use { "goolord/alpha-nvim", config = conf("alpha") }
    use { "ryanoasis/vim-devicons" }
    use {
      "iamcco/markdown-preview.nvim",
      run = "cd app && yarn install",
      ft = { "markdown" },
      setup = function ()
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
    }
    use { "honza/vim-snippets" }
    use {
      'MrcJkb/haskell-tools.nvim',
      requires = {
        'neovim/nvim-lspconfig',
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
      },
      module = "haskell-tools",
      ft = "haskell",
      config = conf("haskell-tools")
    }
    use {
      "j-hui/fidget.nvim",
      config = function ()
        require("fidget").setup()
      end
    }

    -- THEMES
    use { "rktjmp/lush.nvim" }
    use { "arzg/vim-colors-xcode" }
    use { "sainnhe/gruvbox-material" }
    use { "gruvbox-community/gruvbox" }
    use { "folke/tokyonight.nvim" }
    use { "sindrets/material.nvim" }
    use { "sindrets/rose-pine-neovim", as = "rose-pine" }
    use { "mcchrish/zenbones.nvim", requires = "rktjmp/lush.nvim" }
    use { "sainnhe/everforest" }
    use { "Cybolic/palenight.vim" }
    use { "olimorris/onedarkpro.nvim", branch = "main" }
    use { "NTBBloodbath/doom-one.nvim" }
    use { "catppuccin/nvim", as = "catppuccin" }
    use_local { "sindrets/dracula-vim", as = "dracula" }
    use { "projekt0n/github-nvim-theme" }
    use { "rebelot/kanagawa.nvim" }
    use_local { "sindrets/oxocarbon-lua.nvim" }
    use { "nyoom-engineering/oxocarbon.nvim" }
    use { "EdenEast/nightfox.nvim" }
    use { "kvrohit/mellow.nvim" }
  end,

  config = {
    max_jobs = 32,
    auto_reload_compiled = false,
    snapshot_path = vim.fn.stdpath("config"),
    display = {
      open_cmd = "vnew \\[packer\\] | wincmd L | vert resize 70",
    },
  },
})
