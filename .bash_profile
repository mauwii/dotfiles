# shellcheck shell=bash source=.bashrc

# load cross-compatible profile
source ~/.profile

export CLICOLOR=true

# load rc if interactive
if [ "${BASH-no}" != "no" ]; then
    [ -r "$HOME/.bashrc" ] && . "$HOME/.bashrc"
fi
