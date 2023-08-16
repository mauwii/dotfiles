# shellcheck shell=bash

# add shell functions
if [[ -r ~/.functions && "${DOT_FUNCTIONS:-false}" != "true" ]]; then
    # shellcheck source=.functions
    . ~/.functions
fi

debuglog "begin loading .bash_profile"

# load cross-compatible profile if not loaded yet
if [[ -r ~/.profile && "${DOT_PROFILE:-false}" != "true" ]]; then
    # shellcheck source=.profile
    . ~/.profile
fi

# load bashrc if interactive and not loaded yet
if [[ -n "$PS1" && "${DOT_BASHRC:-false}" != "true" && -f ~/.bashrc ]]; then
    # shellcheck source=.bashrc
    . ~/.bashrc
fi

# shellcheck disable=SC2034
DOT_BASHPROFILE="true"

debuglog "done loading .bash_profile"
