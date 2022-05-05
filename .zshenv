#!/usr/bin/env zsh
# vim: set filetype=zsh

# opt out of Azure-Function-Core-Tools Telemetry
FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1

[[ -d /opt/homebrew/share/zsh-syntax-highlighting/highlighters ]] && ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR='/opt/homebrew/share/zsh-syntax-highlighting/highlighters'

# export FZF_DEFAULT_COMMAND='fd --type f'
FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
FZF_DEFAULT_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"

DOCKER_GATEWAY_HOST='127.0.0.1'
