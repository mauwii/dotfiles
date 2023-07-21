#!/bin/sh

# set locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
# for line in $(locale); do
#     KEY="${line%=*}"
#     VALUE="${line#*=}"
#     export "${KEY?}"="$(echo "${VALUE}" | sed 's/\"//g')"
# done

# function to prepend fpath if dir exists
__prepend_fpath() {
    _fpath="$1"
    if [ -d "${1}" ] && echo "${SHELL}" | grep -q "zsh"; then
        _escaped=$(echo "$1" | sed 's/\//\\\//g')
        _cleaned=$(echo "$FPATH" | sed "s/:${_escaped}:/:/g")
        export FPATH="${1}${_cleaned:+:$_cleaned}"
        unset _escaped _cleaned
    fi
    unset _fpath
}

# function to prepend path if dir exists
__prepend_path() {
    _path="$1"
    if [ -d "${_path}" ]; then
        _escaped=$(echo "$_path" | sed 's/\//\\\//g')
        _cleaned=$(echo "$PATH" | sed "s/:${_escaped}:/:/g")
        export PATH="${_path}:${_cleaned}"
        unset _escaped _cleaned
    fi
    unset _path
}

# add brew to env
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # HOMEBREW_BUNDLE_FILE=~/.config/Brewfile
    # if [ -f "$HOMEBREW_BUNDLE_FILE" ]; then
    #     export HOMEBREW_BUNDLE_FILE
    # else
    #     unset HOMEBREW_BUNDLE_FILE
    # fi
    __prepend_fpath "$(brew --prefix)/share/zsh/site-functions"
fi

# Add Ruby gems to PATH.
if command -v ruby >/dev/null && command -v gem >/dev/null; then
    __prepend_path "$(ruby -r rubygems -e 'puts Gem.user_dir')/bin"
fi

# docker bins
__prepend_path ~/.docker/bin

# docker cli-plugins
__prepend_path ~/.docker/cli-plugins

# personal bins
__prepend_path ~/.local/bin

# set PYENV_ROOT if dir exists and not set
if [ -d "${HOME}/.pyenv" ] && [ -z "${PYENV_ROOT}" ]; then
    export PYENV_ROOT="${HOME}/.pyenv"
fi

# add pyenv bins to path if dir exists
__prepend_path "${PYENV_ROOT}/bin"

# initialize pyenv
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# set kubeconfig
_local_kubeconfig="${HOME}/.kube/config.local"
if [ -r "${_local_kubeconfig}" ]; then
    KUBECONFIG="${_local_kubeconfig}${KUBECONFIG:+:$KUBECONFIG}"
    export KUBECONFIG
fi
unset _local_kubeconfig

# set dotnet root if dir exists
DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
if [ -d "${DOTNET_ROOT}" ] && command -v dotnet >/dev/null 2>&1; then
    export DOTNET_ROOT
else
    unset DOTNET_ROOT
fi

# clean manpath
if command -v manpath >/dev/null 2>&1; then
    MANPATH="$(manpath)"
    if [ "$(uname -s)" = Darwin ]; then
        # remove read-only path "/usr/share/man" from MANPATH
        MANPATH="$(echo "$MANPATH" | sed -e 's/:\/usr\/share\/man:/:/g')"
        export MANPATH
    else
        export MANPATH
    fi
fi
