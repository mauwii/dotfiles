# shellcheck shell=bash

# load cross-compatible profile if not loaded yet
if [ -r ~/.profile ] && [ "$PROFILE_LOADED" != "true" ]; then
    # shellcheck source=.profile
    . ~/.profile
fi

# load bashrc if interactive and not loaded yet
if [ -r ~/.bashrc ] && [ "$BASHRC_LOADED" != "true" ]; then
    # shellcheck source=.bashrc
    . ~/.bashrc
fi

export BASHPROFILE_LOADED="true"
