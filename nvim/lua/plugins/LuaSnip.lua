-- :fennel:1659480881
local function _1_()
  local luasnip = require("luasnip")
  local luasnip_loaders_from_vscode = require("luasnip.loaders.from_vscode")
  luasnip.config.set_config({history = true, updateevents = "TextChanged,TextChangedI"})
  luasnip_loaders_from_vscode.lazy_load()
  luasnip_loaders_from_vscode.lazy_load({paths = (vim.g.luasnippets_path or "")})
  local function _2_()
    if (luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active) then
      return luasnip.unlink_current()
    else
      return nil
    end
  end
  return vim.api.nvim_create_autocmd("InsertLeave", {callback = _2_})
end
return {from = "L3MON4D3/LuaSnip", wants = "friendly-snippets", after = "nvim-cmp", config = _1_}