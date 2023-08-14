# shellcheck shell=bash disable=SC2312

# add shell functions
if [[ -r ~/.functions && "${DOT_FUNCTIONS}" != "true" ]]; then
    # shellcheck source=.functions
    . ~/.functions
fi

# check it was not sourced before
if [[ "${DOT_BASHRC:-false}" = "true" ]]; then
    debuglog ".bashrc has already been loaded"
    return
else
    debuglog "loading .bashrc"
fi

# load shared shell configuration if not loaded yet
if [[ "${DOT_SHRC}" != "true" && -r ~/.shrc ]]; then
    # shellcheck source=.shrc
    . ~/.shrc
else
    debuglog ".shrc has already been loaded"
fi

# direnv hook to automatically load/unload .envrc files
if validate_command direnv; then
    eval "$(direnv hook bash)"
fi

# Initialize pyenv
if [[ -d ~/.pyenv && -z "${PYENV_ROOT}" ]]; then
    export PYENV_ROOT=~/.pyenv
    debuglog ".bashrc: setting PYENV_ROOT to %s" "$PYENV_ROOT"
fi
if [[ -n "${PYENV_ROOT}" && -d "${PYENV_ROOT}/bin" ]]; then
    if echo "${PATH}" | grep -q "${PYENV_ROOT}/bin"; then
        export PATH="${PYENV_ROOT}/bin:${PATH//${PYENV_ROOT}\/bin/}"
    fi
fi
if validate_command pyenv; then
    eval "$(pyenv init -)"
fi

# Initialize pyenv-virtualenv
# shellcheck disable=SC2154
if command -v pyenv-virtualenv >/dev/null 2>&1 && [[ "${PYENV_VIRTUALENV_INIT}" != 1 ]]; then
    eval "$(pyenv virtualenv-init -)"
fi

# pipx completion
if command -v pipx >/dev/null 2>&1; then
    eval "$(register-python-argcomplete pipx)"
fi

# load bash completion if available
if [[ -r "${HOMEBREW_PREFIX:-unset}/etc/profile.d/bash_completion.sh" ]]; then
    __bash_completion="${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
elif [[ -r /usr/share/bash-completion/bash_completion ]]; then
    __bash_completion=/usr/share/bash-completion/bash_completion
elif [[ -n ${HOMEBREW_PREFIX} && -d "${HOMEBREW_PREFIX}/etc/bash_completion.d" ]]; then
    debuglog "sourcing completion scripts in %s" "${HOMEBREW_PREFIX}/etc/bash_completion.d"
    find "${HOMEBREW_PREFIX}/etc/bash_completion.d" -type l \
        | while IFS= read -r completionscript; do
            #shellcheck source=/dev/null
            [[ -r "${completionscript}" ]] && . "${completionscript}"
        done
fi
if [[ -f "${__bash_completion}" ]]; then
    # shellcheck source=/dev/null
    . "${__bash_completion}"
    debuglog "%s: found bash_completion at %s" ".bashrc" "${__bash_completion}"
    unset __bash_completion
fi

# initialize starship prompt if available
if validate_command starship; then
    eval "$(starship init bash)"
fi

# source iTerm2 shell integration if available
# shellcheck disable=SC2154
if [[ -r "${HOME}/.iterm2_shell_integration.bash" && ${LC_TERMINAL} == "iTerm2" ]]; then
    # shellcheck source=/dev/null
    . "${HOME}/.iterm2_shell_integration.bash"
    debuglog "%s: sourced iTerm2 shell integration" ".bashrc"
fi

DOT_BASHRC="true"
