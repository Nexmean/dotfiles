return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "stevanmilic/neotest-scala",
  },
  config = function()
    require("neotest").setup {
      adapters = {
        require "neotest-scala" {
          framework = "munit",
        },
      },
    }
  end,
}
