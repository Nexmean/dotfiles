-- :fennel:1659218927
local _var_1_ = require("core.lib")
local call = _var_1_["call"]
local function _2_()
  local cmp = require("cmp")
  local cmp_window = require("cmp.utils.window")
  local luasnip = require("luasnip")
  local ui_icons = require("ui.icons")
  local border
  local function _3_(_2410)
    return {{"\226\148\140", _2410}, {"\226\148\128", _2410}, {"\226\148\144", _2410}, {"\226\148\130", _2410}, {"\226\148\152", _2410}, {"\226\148\128", _2410}, {"\226\148\148", _2410}, {"\226\148\130", _2410}}
  end
  border = _3_
  cmp_window.info_ = cmp_window.info
  local function _4_(self)
    local info = self:info()
    info.scrollable = false
    return info
  end
  cmp_window.info = _4_
  local function _5_(_2410)
    return luasnip.lsp_expand(_2410.body)
  end
  local function _6_(_, vim_item)
    local icons = ui_icons.lspkind
    vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
    return vim_item
  end
  local function _7_(fallback)
    if cmp.visible() then
      return cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
      return vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
    else
      return fallback()
    end
  end
  local function _9_(fallback)
    if cmp.visible() then
      return cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      return vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
    else
      return fallback()
    end
  end
  return cmp.setup({window = {completion = {border = border("CmpBorder"), winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None"}, documentation = {border = border("CmpDocBorder"), winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None"}}, snippet = {expand = _5_}, formatting = {format = _6_}, mapping = {["<C-p>"] = cmp.mapping.select_prev_item(), ["<C-n>"] = cmp.mapping.select_next_item(), ["<C-d>"] = cmp.mapping.scroll_docs(-4), ["<C-f>"] = cmp.mapping.scroll_docs(4), ["<C-Space>"] = cmp.mapping.complete(), ["<C-e>"] = cmp.mapping.close(), ["<CR>"] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = false}), ["<Tab>"] = cmp.mapping(_7_, {"i", "s"}), ["<S-Tab>"] = cmp.mapping(_9_, {"i", "s"})}, sources = {{name = "luasnip"}, {name = "nvim_lsp"}, {name = "buffer"}, {name = "nvim_lua"}, {name = "path"}}})
end
return {from = "hrsh7th/nvim-cmp", after = "friendly-snippets", config = _2_}