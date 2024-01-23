return {
  "stevearc/overseer.nvim",
  opts = {
    -- strategy = {
    --   "toggleterm",
    --   direction = "horizontal",
    --   on_create = function()
    --     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "m", false)
    --   end,
    -- },
    task_list = {
      default_detail = 1,
      direction = "bottom",
      bindings = {
        ["<C-l>"] = false,
        ["<C-h>"] = false,
      },
    },
  },
  config = function(_, opts)
    require("overseer").setup(opts)

    local augroup = vim.api.nvim_create_augroup("OverseerUser", {})
    vim.api.nvim_create_autocmd("BufWinEnter", {
      group = augroup,
      callback = function()
        if vim.o.ft == "OverseerList" then
          require("util.neotree").fix()
        end
      end,
    })
  end,
}
