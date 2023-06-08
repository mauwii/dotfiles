export LANG=en_US.UTF-8

# Begin with a clean path
[[ -x /usr/libexec/path_helper ]] && eval "$(/usr/libexec/path_helper -s)"

# add brew to env
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# private docker bins
DOCKER_BIN="$HOME/.docker/bin"
[[ -d $DOCKER_BIN && $PATH != *"$DOCKER_BIN"* ]] && export PATH="$DOCKER_BIN${PATH+:$PATH}"

# initialize pyenv
[[ -d "$HOME/.pyenv" && -z "$PYENV_ROOT" ]] && export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" && $PATH != *"$PYENV_ROOT/bin"* ]] \
    && export PATH="$PYENV_ROOT/bin${PATH+:$PATH}"
[[ -x $(which pyenv) ]] && eval "$(pyenv init -)"
[[ -x "$(which pyenv-virtualenv-init)" && $PYENV_VIRTUALENV_INIT -ne 1 ]] \
    && eval "$(pyenv virtualenv-init -)"

# clean MANPATH
MANPATH=$(manpath)
export MANPATH
