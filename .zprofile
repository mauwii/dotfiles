#!/usr/bin/env zsh

# ensure .zprofile is only loaded once
if [ "${DOT_ZPROFILE}" = true ]; then
    debuglog "already loaded .zprofile\n"
    return
else
    debuglog "loading .zprofile\n"
fi

# load cross-compatible profile
if [ -r ~/.profile ] && [ "${DOT_PROFILE}" != true ]; then
    source ~/.profile
fi

DOT_ZPROFILE=true
