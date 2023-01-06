local opt = vim.opt

local function list(value, str, sep)
  sep = sep or ","
  str = str or ""
  value = type(value) == "table" and table.concat(value, sep) or value
  return str ~= "" and table.concat({ value, str }, sep) or value
end

vim.g.mapleader = " "

opt.langmap = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,"
  .. "фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz,"

opt.cmdheight = 0
opt.showtabline = 0
opt.number = true
opt.relativenumber = false
opt.autoindent = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = -1
opt.expandtab = true
opt.ignorecase = true
opt.smartcase = true
opt.wildignorecase = true
opt.showcmd = true
opt.mouse = "a"
opt.hidden = true
opt.cursorline = true
opt.guifont = "JetbrainsMono Nerd Font:h16"
opt.guicursor = list {
  "n-v-c-sm:block-Cursor/lCursor",
  "i-ci-ve:ver25-Cursor/lCursor",
  "r-cr-o:hor20",
}
opt.splitbelow = true
opt.splitright = true
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.swapfile = true
opt.shortmess = "filnxtToOFIAS"
opt.updatetime = 4096 -- change cursorhold time with 'vim.g.cursorhold_updatetime'
opt.termguicolors = true
opt.backspace = list { "indent", "eol", "start" }
opt.inccommand = "split"
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
-- opt.foldlevelstart = 99
opt.foldlevel = 99 -- 'foldlevelstart' isn't working correctly?
opt.scrolloff = 3
opt.completeopt = list { "menuone", "noselect" }
opt.virtualedit = list { "block" }
opt.signcolumn = "yes:2"
opt.colorcolumn = list { "100" }
opt.sessionoptions = list {
  "blank",
  "buffers",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winpos",
}
opt.diffopt = list {
  "algorithm:histogram",
  "internal",
  "indent-heuristic",
  "filler",
  "closeoff",
  "iwhite",
  "vertical",
}
opt.pyxversion = 3
opt.shada = list {
  "!",
  "'10",
  "/100",
  ":100",
  "<0",
  "@1",
  "f1",
  "h",
  "s1",
}
opt.list = true
opt.listchars = list {
  "tab: ──",
  "lead:·",
  "trail:•",
  "nbsp:␣",
  -- "eol:↵",
  "precedes:«",
  "extends:»",
}
opt.fillchars = list {
  -- "vert:▏",
  "vert:│",
  "diff:╱",
  "foldclose:",
  "foldopen:",
  "fold: ",
  "msgsep:─",
  "eob: ",
}
opt.showbreak = "⤷ "
opt.concealcursor = "nc"
opt.writebackup = true
opt.undofile = true
opt.isfname:append ":"
opt.laststatus = 3
-- TODO: Lazyredraw is causing cursor flickering at the moment. Hopefully
-- re-enable soon when this is fixed.
-- @see [Neovim issue](https://github.com/neovim/neovim/issues/17765)
opt.lazyredraw = false

if vim.fn.executable "ag" == 1 then
  opt.grepprg = "ag --vimgrep $*"
  opt.grepformat = "%f:%l:%c:%m"
end

if vim.fn.executable "nvr" == 1 then
  vim.env.NVIM_LISTEN_ADDRESS = vim.v.servername
  vim.env.GIT_EDITOR = "nvr -cc split +'setl bh=delete' --remote-wait"
  vim.env.EDITOR = "nvr -l --remote"
  vim.env.VISUAL = "nvr -l --remote"
end

vim.env.MANWIDTH = 80 -- Text width in man pages.

-- vim.cmd("syntax on")
vim.cmd "filetype plugin indent on"

if vim.g.neovide then
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_trail_length = 0
  vim.g.neovide_floating_blur = false
  vim.g.neovide_floating_opacity = 1.0
  vim.g.neovide_refresh_rate = 240
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_scroll_animation_length = 0.05
end
