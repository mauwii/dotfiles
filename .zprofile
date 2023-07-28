#!/usr/bin/env zsh

# load cross-compatible profile
if [ -r ~/.profile ] && [ "${DOT_PROFILE}" != "true!" ]; then
    source ~/.profile
fi

# # load ~/.zshrc if not loaded yet
# if [ "${DOT_ZSHRC}" != "true" ] && [ -r ~/.zshrc ]; then
#     source ~/.zshrc
# fi

export DOT_ZPROFILE="true"
