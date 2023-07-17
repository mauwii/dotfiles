# shellcheck shell=bash source=./.bashrc

source ~/.profile

# load rc if interactive
if [ "${BASH-no}" != "no" ]; then
    [ -r "$HOME/.bashrc" ] && . "$HOME/.bashrc"
fi
