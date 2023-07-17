# shellcheck shell=bash source=/dev/null

# chck if this is a interactive shell
if [ -z "$PS1" ]; then
    return
fi

# add ESP-IDF Directory if it exists
IDF_PATH="$HOME/esp/esp-idf"
if [ -d "$IDF_PATH" ] && [ -s "$IDF_PATH"/export.sh ]; then
    export ESPIDF="$IDF_PATH"
    alias getidf='. "${ESPIDF}/export.sh"'
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
if which -s pyenv-virtualenv && [ "$PYENV_VIRTUALENV_INIT" != 1 ]; then
    eval "$(pyenv virtualenv-init -)"
fi

alias l="ls -a -h"
alias ll="l -l -g"
alias lll="ll -@"
alias lr="ls -R"
alias llr="lr -l"

# replace cat with bat, but disable paging to make it behave like cat
if which -s bat; then
    alias cat="bat --paging=never"
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
