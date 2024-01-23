return {
  "NeogitOrg/neogit",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "Neogit" },

  config = function()
    require("neogit").setup({
      disable_signs = false,
      disable_hint = true,
      disable_context_highlighting = false,
      disable_builtin_notifications = true,
      status = {
        recent_commit_count = 50,
      },
      -- customize displayed signs
      signs = {
        -- { CLOSED, OPENED }
        section = { "", "" },
        item = { "", "" },
        hunk = { "", "" },
      },
      sections = {
        recent = {
          folded = false,
        },
        stashes = {
          folded = true,
        },
      },
      -- override/add mappings
      mappings = {
        -- modify status buffer mappings
        status = {
          -- -- Adds a mapping with "B" as key that does the "BranchPopup" command
          -- ["B"] = "BranchPopup",
        },
      },
    })

    local augroup_id = vim.api.nvim_create_augroup("neogit_config", {})

    vim.api.nvim_create_autocmd("FileType", {
      group = augroup_id,
      pattern = "Neogit*",
      command = "setl nolist",
    })

    vim.api.nvim_create_autocmd({ "BufEnter, FileType" }, {
      group = augroup_id,
      pattern = "NeogitCommitView",
      command = "setl eventignore+=CursorMoved",
    })

    vim.api.nvim_create_autocmd("BufLeave", {
      group = augroup_id,
      pattern = "NeogitCommitView",
      command = "setl eventignore-=CursorMoved",
    })
  end,
}
