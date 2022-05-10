#!/usr/bin/env zsh
# vim: set filetype=zsh

# export FZF_DEFAULT_COMMAND='fd --type f'
FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
FZF_DEFAULT_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
