# shellcheck shell=bash source=/dev/null

# chck if this is a interactive shell
if [ -z "$PS1" ]; then
    return
fi

# source aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable cli color
export CLICOLOR=true

# add ESP-IDF Directory if it exists
IDF_PATH=~/esp/esp-idf
if [ -f "${IDF_PATH}/export.sh" ]; then
    export ESPIDF="${IDF_PATH}"
    alias getidf='. ${ESPIDF}/export.sh'
else
    unset IDF_PATH
fi

# direnv hook to automatically load/unload .envrc files
if which -s direnv; then eval "$(direnv hook bash)"; fi

# Initialize pyenv
if [ -d ~/.pyenv ] && [ -z "$PYENV_ROOT" ]; then
    export PYENV_ROOT=~/.pyenv
fi
if [ -d "$PYENV_ROOT/bin" ]; then
    if echo "$PATH" | grep -q "$PYENV_ROOT/bin"; then
        export PATH="$PYENV_ROOT/bin:${PATH//${PYENV_ROOT}\/bin/}"
    fi
fi
if which -s pyenv; then eval "$(pyenv init -)"; fi

# Initialize pyenv-virtualenv
if which -s pyenv-virtualenv && [ "$PYENV_VIRTUALENV_INIT" != 1 ]; then
    eval "$(pyenv virtualenv-init -)"
fi

# pipx completion
if command -v pipx >/dev/null 2>&1; then
    eval "$(register-python-argcomplete pipx)"
fi

# brew completion
if [ -d "$HOMEBREW_PREFIX" ]; then
    if [ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
        . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
    else
        for completionscript in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
            [ -r "${completionscript}" ] && . "$completionscript"
        done
    fi
fi

# initialize starship prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
# source bash_prompt if starship is not available
elif [ -f ~/.bash_prompt ]; then
    . ~/.bash_prompt
fi
