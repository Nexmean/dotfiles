source ~/.zshenv

source $ANTIGEN_PATH

antigen bundle zdharma-continuum/fast-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions

antigen use oh-my-zsh

antigen bundle completion
antigen bundle history
antigen bundle key-bindings

antigen apply

alias -g e="nvim"
alias -g ls="exa"
alias -g la="ls -la"

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
