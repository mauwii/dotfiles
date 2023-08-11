# shellcheck shell=bash

# add shell functions
if [[ -r ~/.functions && "${DOT_FUNCTIONS}" != "true" ]]; then
    # shellcheck source=.functions
    . ~/.functions
fi

debuglog "loading .bash_profile"

# load cross-compatible profile if not loaded yet
if [[ -r ~/.profile && "${DOT_PROFILE}" != "true" ]]; then
    # shellcheck source=.profile
    . ~/.profile
fi

# load bashrc if interactive and not loaded yet
if [[ "${PS1:-x}" != "x" && "${DOT_BASHRC}" != "true" && -r "${HOME}/.bashrc" ]]; then
    # shellcheck source=.bashrc
    . "${HOME}/.bashrc"
fi

# shellcheck disable=SC2034
DOT_BASHPROFILE="true"
