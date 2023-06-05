return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-file-browser.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-media-files.nvim" },
    { "nvim-telescope/telescope-live-grep-args.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "ahmedkhalf/project.nvim" },
    { "olimorris/persisted.nvim" },
    { "debugloop/telescope-undo.nvim" },
  },
  cmd = { "Telescope" },
  config = require "user.plugins.ui.telescope.config",
}
