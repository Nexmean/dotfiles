local lazy = require "user.plugins.lazy"

lazy.register_plugins "completion"
lazy.register_plugins "editor"
lazy.register_plugins "lsp"
lazy.register_plugins "mini"
lazy.register_plugins "project"
lazy.register_plugins "quickfix"
lazy.register_plugins "syntax"
lazy.register_plugins "themes"
lazy.register_plugins "treesitter"
lazy.register_plugins "ui"
lazy.register_plugins "vcs"

lazy.register_plugin { "nvim-lua/plenary.nvim" }
lazy.register_plugin {
  "Nexmean/caskey.nvim",
  -- dir = "~/programming/neovim/caskey.nvim",
  dependencies = { "folke/which-key.nvim" },
  config = function()
    require("caskey.wk").setup(require "user.mappings")
  end,
}

lazy.setup()
