# Description: This file is sourced by all zsh shells, unless the -f option is set.

# ensure unique entrys in PATH
typeset -U PATH

# zsh will source other shellscripts from this directory
export ZDOTDIR="${HOME}/.config/zsh"

# add shell functions
if [ -r ~/.functions ]; then
    # shellcheck source=.functions
    . ~/.functions
fi
