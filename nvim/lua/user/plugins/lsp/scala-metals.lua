return {
  "scalameta/nvim-metals",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local metals = require "metals"

    local metals_config = Config.lsp.create_config(metals.bare_config())
    Config.lsp.metals_config = metals_config

    local metals_group = vim.api.nvim_create_augroup("scala-metals", { clear = false })

    metals_config.settings = {
      showImplicitArguments = true,
      showInferredType = true,
    }
    metals_config.init_options.statusBarProvider = "off"

    metals_config.on_attach = Config.lsp.sequence_on_attach(
      metals_config.on_attach,
      function(_, bufnr)
        require("caskey.utils").emit(metals_group, bufnr)
      end
    )

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "scala", "sbt", "java" },
      group = metals_group,
      callback = function()
        metals.initialize_or_attach(metals_config)
      end,
    })
  end,
}
