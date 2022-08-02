(var {: call} (require :core.lib))

{
  :from     :nvim-telescope/telescope-frecency.nvim
  :requires :tami5/sqlite.lua
  :after    :telescope
  :config   #((. (require :telescope) :load_extension) :frecency)
}
