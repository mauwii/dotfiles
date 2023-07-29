#!/usr/bin/env zsh

# ensure .zprofile is only loaded once
if [ "${DOT_ZPROFILE}" = true ]; then
    [ "${DEBUG}" = true ] && printf "already loaded .zprofile\n"
    return
else
    [ "${DEBUG}" = true ] && printf "loading .zprofile\n"
fi

# load cross-compatible profile
if [ -r ~/.profile ] && [ "${DOT_PROFILE}" != true ]; then
    source ~/.profile
fi

export DOT_ZPROFILE=true
