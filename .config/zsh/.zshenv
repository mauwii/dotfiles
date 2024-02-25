# Description: This file is sourced by all zsh shells, unless the -f option is set.

# ensure unique entrys in PATH
typeset -U PATH

# zsh will source other shellscripts from this directory
export ZDOTDIR="${HOME}/.config/zsh"

# add DOETNET_ROOT
if [ -d /opt/homebrew/opt/dotnet/libexec ]; then
    export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
fi
