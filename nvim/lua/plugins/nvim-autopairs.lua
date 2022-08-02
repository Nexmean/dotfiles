-- :fennel:1659480757
local function _1_()
  local autopairs = require("nvim-autopairs")
  local cmp = require("cmp")
  autopairs.setup({fast_wrap = {}, disable_filetype = {"TelescopePrompt", "vim"}})
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  return (cmp.event):on("confirm_done", cmp_autopairs.on_confirm_done())
end
return {from = "windwp/nvim-autopairs", after = "nvim-cmp", config = _1_}