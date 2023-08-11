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

# load bash completion if available
if [[ -f /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
    bash_completion=/opt/homebrew/etc/profile.d/bash_completion.sh
elif [[ -f /usr/share/bash-completion/bash_completion ]]; then
    bash_completion=/usr/share/bash-completion/bash_completion
fi
if [[ $PS1 && -r "${bash_completion}" ]]; then
    # shellcheck source=/dev/null
    . "${bash_completion}"
fi

# load bashrc if interactive and not loaded yet
if [[ $PS1 && -r ~/.bashrc && "${DOT_BASHRC:-false}" != "true" ]]; then
    # shellcheck source=.bashrc
    . ~/.bashrc
fi

# shellcheck disable=SC2034
DOT_BASHPROFILE="true"
