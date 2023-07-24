# shellcheck shell=bash

# load cross-compatible profile
# shellcheck source=.profile
. ~/.profile

# load rc if interactive
if [ "${BASH-no}" != "no" ]; then
    [ -r "$HOME/.bashrc" ] && . "$HOME/.bashrc"
fi
