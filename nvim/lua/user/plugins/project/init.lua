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
        should_autosave = function()
          return vim.bo.filetype ~= "alpha"
        end,
      }

      local group = vim.api.nvim_create_augroup("PersistedHooks", {})

      vim.api.nvim_create_autocmd("user", {
        pattern = "PersistedSavePre",
        group = group,
        callback = function()
          vim.cmd [[Neotree close]]
          pcall(require("neogit").close)
        end,
      })
    end,
  },
}
