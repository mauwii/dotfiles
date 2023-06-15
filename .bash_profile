# shellcheck shell=bash source=./.bashrc

# set language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Begin with a clean path
if [ -x /usr/libexec/path_helper ]; then eval "$(/usr/libexec/path_helper -s)"; fi

# clear manpath
MANPATH=$(manpath)
export MANPATH

# add brew to env
if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi

# brew completion
if [ -d "$HOMEBREW_PREFIX" ]; then
    if [ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
        . "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
    else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
            [ -r "${COMPLETION}" ] && . "${COMPLETION}"
        done
    fi
fi

# Initialize pyenv
if [ -d "$HOME/.pyenv" ] && [ -z "$PYENV_ROOT" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
fi
if [ -d "$PYENV_ROOT/bin" ]; then
    if echo "$PATH" | grep -p "$PYENV_ROOT/bin"; then
        export PATH="$PYENV_ROOT/bin${PATH+:$PATH}"
    fi
fi
if which -s pyenv; then eval "$(pyenv init -)"; fi

# load rc if interactive
if [ "${BASH-no}" != "no" ]; then
    [ -r "$HOME/.bashrc" ] && . "$HOME/.bashrc"
fi
