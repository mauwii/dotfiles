# shellcheck shell=bash
set -x

[ "$DEBUG" = "true" ] && printf "loading .bash_profile\n"

# load cross-compatible profile if not loaded yet
if [ -r ~/.profile ] && [ "$DOT_PROFILE" != "true" ]; then
    # shellcheck source=.profile
    . ~/.profile
fi

# load bashrc if interactive and not loaded yet
if [ -r ~/.bashrc ] && [ "$DOT_BASHRC" != "true" ]; then
    # shellcheck source=.bashrc
    . ~/.bashrc
fi

export DOT_BASHPROFILE="true"
