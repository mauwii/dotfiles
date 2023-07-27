#!/usr/bin/env zsh

# load cross-compatible profile
if [ -r ~/.profile ]; then
    source ~/.profile
fi

# # load ~/.zshrc if not loaded yet
# if [ "${ZSHRC_LOADED}" != "true" ] && [ -r ~/.zshrc ]; then
#     source ~/.zshrc
# fi

export ZPROFILE_LOADED="true"
