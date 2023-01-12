return {
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        manual_mode = true,
      }
    end,
  },

  {
    "olimorris/persisted.nvim",
    config = function()
      require("persisted").setup {
        use_git_branch = true,
        before_save = function()
          vim.cmd [[Neotree close]]
          pcall(require("neogit").close)
        end,
        should_autosave = function()
          return vim.bo.filetype ~= "alpha"
        end,
      }
    end,
  },
}
