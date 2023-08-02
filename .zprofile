# shellcheck shell=bash

# ensure .zprofile is only loaded once
if [ "${DOT_ZPROFILE}" = "true" ]; then
    debuglog "already loaded .zprofile"
    return
else
    debuglog "loading .zprofile"
fi

# load cross-compatible profile
if [ -r ~/.profile ] && [ "${DOT_PROFILE}" != "true" ]; then
    # shellcheck source=.profile
    source ~/.profile
fi

DOT_ZPROFILE="true"
