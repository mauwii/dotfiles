# shellcheck shell=bash source=./.bashrc
export LANG=en_US.UTF-8

# Begin with a clean path
if [[ -x /usr/libexec/path_helper ]]; then eval "$(/usr/libexec/path_helper -s)"; fi

# add brew to env
if [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi

# # brew bash completion@2
HB_BASH_COMPLETION="$(brew --prefix)/etc/profile.d/bash_completion.sh"
if [[ -s "$HB_BASH_COMPLETION" ]]; then . "$HB_BASH_COMPLETION"; fi

# Initialize pyenv
if [[ -d "$HOME/.pyenv" && -z "$PYENV_ROOT" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
fi
if [[ -d "$PYENV_ROOT/bin" && $PATH != *"$PYENV_ROOT/bin"* ]]; then
    export PATH="$PYENV_ROOT/bin${PATH+:$PATH}"
fi
if [[ -x "$(which pyenv)" ]]; then eval "$(pyenv init -)"; fi

# clear manpath
MANPATH=$(manpath)
export MANPATH

if [ "${BASH-no}" != "no" ]; then
    [ -r "$HOME/.bashrc" ] && . "$HOME/.bashrc"
fi
