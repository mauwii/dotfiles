# shellcheck shell=bash

if [ "${DEBUG:-false}" = "true" ]; then
    printf "[%s] loading .bash_profile\n" "$(date "+%T")"
fi

# load cross-compatible profile if not loaded yet
if [ -r ~/.profile ] && [ "${DOT_PROFILE:-false}" != "true" ]; then
    # shellcheck source=.profile
    . ~/.profile
fi

# load bashrc if interactive and not loaded yet
if [ -r ~/.bashrc ] && [ "${DOT_BASHRC:-false}" = "false" ]; then
    # shellcheck source=.bashrc
    . ~/.bashrc
fi

# shellcheck disable=SC2034
DOT_BASHPROFILE="true"
