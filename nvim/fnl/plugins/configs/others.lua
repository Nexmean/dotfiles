local M = {}

M.autopairs = function()
   local present1, autopairs = pcall(require, "nvim-autopairs")
   local present2, cmp = pcall(require, "cmp")

   if not (present1 and present2) then
      return
   end

   local options = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
   }

   autopairs.setup(options)

   local cmp_autopairs = require "nvim-autopairs.completion.cmp"
   cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

M.blankline = function()
   local present, blankline = pcall(require, "indent_blankline")

   if not present then
      return
   end

   local options = {
      indentLine_enabled = 1,
      filetype_exclude = {
         "help",
         "terminal",
         "alpha",
         "packer",
         "lspinfo",
         "TelescopePrompt",
         "TelescopeResults",
         "lsp-installer",
         "",
      },
      buftype_exclude = { "terminal" },
      show_trailing_blankline_indent = false,
      show_first_indent_level = false,
      show_current_context = true,
      show_current_context_start = true,
   }

   blankline.setup(options)
end

M.comment = function()
   local present, nvim_comment = pcall(require, "Comment")

   if not present then
      return
   end

   local options = {}
   nvim_comment.setup(options)
end

M.luasnip = function()
   local present, luasnip = pcall(require, "luasnip")

   if not present then
      return
   end

   local options = {
      history = true,
      updateevents = "TextChanged,TextChangedI",
   }

   luasnip.config.set_config(options)
   require("luasnip.loaders.from_vscode").lazy_load()
   require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.luasnippets_path or "" }

   vim.api.nvim_create_autocmd("InsertLeave", {
      callback = function()
         if
            require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
            and not require("luasnip").session.jump_active
         then
            require("luasnip").unlink_current()
         end
      end,
   })
end

M.gitsigns = function()
   local present, gitsigns = pcall(require, "gitsigns")

   if not present then
      return
   end

   local options = {
   }

   gitsigns.setup(options)
end

return M
