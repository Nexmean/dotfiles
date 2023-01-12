return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
      {
        "L3MON4D3/LuaSnip",
        version = "v1.*",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      { "hrsh7th/cmp-cmdline" },
      { "f3fora/cmp-spell" },
      { "petertriho/cmp-git" },
      { "rafamadriz/friendly-snippets" },
    },
    event = { "InsertEnter", "CmdlineEnter" },

    config = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      local api = vim.api
      local utils = Config.common.utils

      local lsp_kinds = {
        Method = "  ",
        Function = " ƒ ",
        Variable = "  ",
        Field = "  ",
        TypeParameter = "  ",
        Constant = "  ",
        Class = "  ",
        Interface = " 蘒",
        Struct = "  ",
        Event = "  ",
        Operator = "  ",
        Module = "  ",
        Property = "  ",
        Enum = "  ",
        Reference = "  ",
        Keyword = "  ",
        File = "  ",
        Folder = " ﱮ ",
        Color = "  ",
        Unit = " 塞 ",
        Snippet = "  ",
        Text = "  ",
        Constructor = "  ",
        Value = "  ",
        EnumMember = "  ",
      }

      -- Prevent event listeners from stacking whenever packer reloads the config.
      cmp.event:clear()

      cmp.setup {
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm { select = false, behavior = cmp.ConfirmBehavior.Replace },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        formatting = {
          deprecated = true,
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            vim_item.kind = lsp_kinds[vim_item.kind]
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              emoji = "[Emoji]",
              path = "[Path]",
              calc = "[Calc]",
              neorg = "[Neorg]",
              orgmode = "[Org]",
              luasnip = "[Luasnip]",
              buffer = "[Buffer]",
              spell = "[Spell]",
              git = "[VCS]",
            })[entry.source.name]
            return vim_item
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          documentation = {
            border = "single",
            winhighlight = "Normal:Normal,CursorLine:Visual,Search:None",
            zindex = 1001,
          },
        },
        sources = {
          { name = "nvim_lua" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "git" },
          { name = "spell" },
          { name = "path" },
          {
            name = "buffer",
            max_item_count = 20,
            option = {
              get_bufnrs = function()
                return vim.tbl_filter(
                  function(bufnr)
                    local bytesize = api.nvim_buf_get_offset(bufnr, api.nvim_buf_line_count(bufnr))
                    return bytesize < 1024 * 1024
                  end,
                  utils.vec_union(
                    utils.list_bufs { listed = true },
                    utils.list_bufs { no_hidden = true }
                  )
                )
              end,
            },
          },
        },
        -- sorting = {
        --   comparators = {
        --     function(...) return cmp_buffer:compare_locality(...) end,
        --   },
        -- },
      }

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      require("cmp_git").setup {
        filetypes = { "gitcommit", "NeogitCommitMessage", "markdown", "octo" },
      }
    end,
  },
}