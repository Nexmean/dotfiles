# My custom neovim setup based on [NvChad](https://github.com/NvChad/NvChad)

## Features
- all [NvChad](https://github.com/NvChad/NvChad) features
- more filepath info in statusline
- use telescope.nvim for lsp actions
- haskell highlighting, lsp and formatting
- vim-surround, easymotion(hop.nvim), scrollbar
- editorconfig
- plugins are lazy loading so neovim starts blazingly fast

## Requirements
- neovim
- luv (version from brew doesn't work properly)
- nerd font
- haskell-language-server
- stylish-haskell
- neovide (optional: for better GUI)

## Setup
- install [neovim](http://neovim.io/)
- install [NvChad](https://github.com/NvChad/NvChad)
- `git clone git@gitlab.com:next.meaning/dotfiles.git`
- `ln -s dotfiles/nvim/lua/custom ~/.config/nvim/lua/custom`
- run `:PackerSync` in nvim
- restart nvim

## Mappings
Open:
- `~/.config/nvim/lua/core/mappings.lua` to see default NvChad mappings
- `dotfiles/nvim/lua/custom/mappings.lua` to see custom mappings

## Plugins
Custom plugins configured in `nvim/lua/custom/plugins/init.lua`
