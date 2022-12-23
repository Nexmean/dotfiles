local pl = Config.common.utils.pl
local opt = vim.opt

local data_backup = vim.fn.stdpath("data") .. "/backup"
local data_undo = vim.fn.stdpath("data") .. "/undo"

opt.backupdir = data_backup
opt.undodir = data_undo

if pl:is_dir(data_backup) then
  vim.fn.mkdir(data_backup, "p")
end

if pl:is_dir(data_undo) then
  vim.fn.mkdir(data_undo, "p")
end

local init_extra_path = pl:parent(pl:vim_expand("$MYVIMRC")) .. "/init_extra.vim"
if pl:readable(init_extra_path) then
  vim.cmd("source " .. vim.fn.fnameescape(init_extra_path))
end

