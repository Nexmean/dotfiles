local html_like_ft = {
  "html",
  "javascript",
  "typescript",
  "javascriptreact",
  "typescriptreact",
  "svelte",
  "vue",
  "tsx",
  "jsx",
  "rescript",
  "xml",
  "php",
  "markdown",
  "glimmer",
  "handlebars",
  "hbs",
}

return {
  "formatter",
  "indent-blankline",
  "nvim-colorizer",
  "pretty-fold",
  "vim-illuminate",

  { "phaazon/hop.nvim", branch = "v2", config = true },

  {
    "Darazaki/indent-o-matic",
    commit = "bf37c6e",
    opts = {
      -- Number of lines without indentation before giving up (use -1 for infinite)
      max_lines = 2048,
      -- Space indentations that should be detected
      standard_widths = { 2, 3, 4, 8 },
      -- Skip multi-line comments and strings (more accurate detection but less performant)
      skip_multiline = true,
    },
  },

  { "gpanders/editorconfig.nvim" },

  { "godlygeek/tabular", cmd = "Tabularize" },

  { "windwp/nvim-ts-autotag", config = true, ft = html_like_ft },

  {
    "mattn/emmet-vim",
    ft = html_like_ft,
    init = function()
      vim.g.user_emmet_leader_key = "<C-Z>"
    end,
  },

  { "tpope/vim-abolish" },

  { "Rasukarusan/nvim-block-paste" },
}
