# shellcheck shell=bash

# add shell functions
if [ -r ~/.functions ] && [ "${DOT_FUNCTIONS:-false}" != "true" ]; then
    # shellcheck source=.functions
    . ~/.functions
fi

debuglog "loading .bash_profile"

# load cross-compatible profile if not loaded yet
if [[ -r ~/.profile && "${DOT_PROFILE:-false}" != "true" ]]; then
    # shellcheck source=.profile
    . ~/.profile
fi

# load bashrc if interactive and not loaded yet
if [[ "x${PS1}" != "x" && "${DOT_BASHRC:-false}" != "true" ]]; then
    # shellcheck source=.bashrc
    [ -r "${HOME}/.bashrc" ] && . "${HOME}/.bashrc"
fi

# shellcheck disable=SC2034
DOT_BASHPROFILE="true"
