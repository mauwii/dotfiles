# shellcheck shell=bash source=/dev/null
if [ -z "$PS1" ]; then
   return
fi

# add ESP-IDF Directory if it exists
IDF_PATH="$HOME/esp/esp-idf"
if [[ -d "$IDF_PATH" && -s "${IDF_PATH}/export.sh" ]]; then
    export ESPIDF="$IDF_PATH"
    alias getidf='source "${ESPIDF}/export.sh"'
fi

# direnv hook to automatically load/unload .envrc files
if [[ -x "$(which direnv)" ]]; then eval "$(direnv hook bash)"; fi

# fuzzy finder
if [[ -s "$HOME/.fzf.bash" ]]; then source "$HOME/.fzf.bash"; fi

# private docker bins
DOCKER_BIN="$HOME/.docker/bin"
if [[ -d "$DOCKER_BIN" && $PATH != *"$DOCKER_BIN"* ]]; then
    export PATH="$DOCKER_BIN${PATH+:$PATH}"
fi

# Initialize pyenv
if [[ -d "$HOME/.pyenv" && -z "$PYENV_ROOT" ]]; then export PYENV_ROOT="$HOME/.pyenv"; fi
if [[ -d "$PYENV_ROOT/bin" && $PATH != *"$PYENV_ROOT/bin"* ]]; then
    export PATH="$PYENV_ROOT/bin${PATH+:$PATH}"
fi
if [[ -x $(which pyenv) ]]; then eval "$(pyenv init -)"; fi
if [[ -x "$(which pyenv-virtualenv)" && $PYENV_VIRTUALENV_INIT -ne 1 ]]; then
    eval "$(pyenv virtualenv-init -)"
fi

alias ls='ls --color=auto'
