#!/usr/bin/env bash

# load shared shell configuration if not loaded yet
if [ "$DOT_SHRC" != "true" ] && [ -r ~/.shrc ]; then
    # shellcheck source=.shrc
    . ~/.shrc
fi

[ "$DEBUG" = "true" ] && printf "loading .bashrc\n"

# add ESP-IDF Directory if it exists
IDF_PATH=~/esp/esp-idf
if [ -f "${IDF_PATH}/export.sh" ]; then
    export ESPIDF="${IDF_PATH}"
    alias getidf='. ${ESPIDF}/export.sh'
else
    unset IDF_PATH
fi

# direnv hook to automatically load/unload .envrc files
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook bash)"
fi

# Initialize pyenv
if [ -d ~/.pyenv ] && [ -z "${PYENV_ROOT}" ]; then
    export PYENV_ROOT=~/.pyenv
    [ "$DEBUG" = "true" ] \
        && printf "setting PYENV_ROOT to %s\n" "$PYENV_ROOT"
fi
if [ -n "$PYENV_ROOT" ] && [ -d "${PYENV_ROOT}/bin" ]; then
    if echo "${PATH}" | grep -q "$PYENV_ROOT/bin"; then
        export PATH="${PYENV_ROOT}/bin:${PATH//${PYENV_ROOT}\/bin/}"
    fi
fi
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# Initialize pyenv-virtualenv
if command -v pyenv-virtualenv >/dev/null 2>&1 && [ "$PYENV_VIRTUALENV_INIT" != 1 ]; then
    eval "$(pyenv virtualenv-init -)"
fi

# pipx completion
if command -v pipx >/dev/null 2>&1; then
    eval "$(register-python-argcomplete pipx)"
fi

# brew completion
if [ -d "${HOMEBREW_PREFIX}" ]; then
    if [ -r "${HOMEBREW_PREFIX}"/etc/profile.d/bash_completion.sh ]; then
        # shellcheck source=/dev/null
        . "${HOMEBREW_PREFIX}"/etc/profile.d/bash_completion.sh
    else
        find "${HOMEBREW_PREFIX}"/etc/bash_completion.d -type l \
            | while IFS= read -r completionscript; do
                #shellcheck source=/dev/null
                [ -r "${completionscript}" ] && . "${completionscript}"
            done
    fi
fi

# initialize starship prompt if available
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

export DOT_BASHRC="true"
