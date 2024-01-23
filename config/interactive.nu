#!/usr/bin/env nu

# load the dorothy defaults
source ~/.local/share/dorothy/config/interactive.nu

$env.DOROTHY_THEME = 'starship'

source ~/.local/share/atuin/init.nu

register ../deps/nu_plugin_bash_env/nu_plugin_bash_env

bash-env $"($env.HOME)/dotfiles/config/env.sh" | load-env

