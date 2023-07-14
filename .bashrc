# shellcheck shell=bash source=/dev/null

# chck if this is a interactive shell
if [ -z "$PS1" ]; then
    return
fi

# You may need to manually set your language environment
export LANG=en_US.UTF-8
# export LC_ALL=en_US.UTF-8
eval "$(locale)"

# add ESP-IDF Directory if it exists
IDF_PATH="$HOME/esp/esp-idf"
if [ -d "$IDF_PATH" ] && [ -s "$IDF_PATH"/export.sh ]; then
    export ESPIDF="$IDF_PATH"
    alias getidf='. "${ESPIDF}/export.sh"'
fi

# direnv hook to automatically load/unload .envrc files
if which -s direnv; then eval "$(direnv hook bash)"; fi

# private docker bins
DOCKER_BIN="$HOME/.docker/bin"
if echo "$PATH" | grep -q "$DOCKER_BIN"; then
    export PATH="$DOCKER_BIN${PATH+:$PATH}"
fi

# Initialize pyenv
if [ -d "$HOME/.pyenv" ] && [ -z "$PYENV_ROOT" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
fi

if [ -d "$PYENV_ROOT/bin" ]; then
    if echo "$PATH" | grep -q "$PYENV_ROOT/bin"; then
        export PATH="$PYENV_ROOT/bin${PATH:+:$PATH}"
    fi
fi
if which -s pyenv; then eval "$(pyenv init -)"; fi
if which -s pyenv-virtualenv && [ "$PYENV_VIRTUALENV_INIT" != 1 ]; then
    eval "$(pyenv virtualenv-init -)"
fi

# use exa as modern ls-replacement
if which -s exa; then
    alias ls="exa --icons --group-directories-first"
else
    alias ls="ls --color=auto"
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
