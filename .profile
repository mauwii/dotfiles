#!/bin/sh

# set locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# set command mode
export COMMAND_MODE="unix2003"

# function to prepend fpath if dir exists
__prepend_fpath() {
    _fpath="$1"
    if [ -d "${_fpath}" ] && echo "${SHELL}" | grep -q "zsh"; then
        _escaped=$(echo "$_fpath" | sed 's/\//\\\//g')
        _cleaned=$(echo "$FPATH" | sed "s/:${_escaped}:/:/g")
        export FPATH="${_fpath}${_cleaned:+:$_cleaned}"
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
    __prepend_fpath "${HOMEBREW_PREFIX}/share/zsh/site-functions"
    __prepend_fpath "${HOMEBREW_PREFIX}/share/zsh-completions"
fi

# Add Ruby gems to PATH.
if command -v ruby >/dev/null && command -v gem >/dev/null; then
    __prepend_path "$(ruby -r rubygems -e 'puts Gem.user_dir')/bin"
fi

# docker bins
__prepend_path "$HOME/.docker/bin"

# docker cli-plugins
__prepend_path "$HOME/.docker/cli-plugins"

# personal bins
__prepend_path "$HOME/.local/bin"

# set PYENV_ROOT if dir exists and not set
if [ -d "${HOME}/.pyenv" ] && [ -z "${PYENV_ROOT}" ]; then
    export PYENV_ROOT="${HOME}/.pyenv"
fi

# add pyenv bins to path if dir exists
__prepend_path "${PYENV_ROOT}/bin"

# initialize pyenv
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init --path)"
fi

# set kubeconfig
_local_kubeconfig="${HOME}/.kube/config"
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

# change docker socket
DOCKER_HOST="$HOME/.docker/run/docker.sock"
context=$(docker context show)
if [ -S "$DOCKER_HOST" ] && [ ! -S /var/run/docker.socket ] && [ "$context" = "default" ]; then
    export DOCKER_HOST="unix://$DOCKER_HOST"
else
    unset DOCKER_HOST
fi
unset context

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

if [ "$SHELL" = "/bin/sh" ]; then
    # shellcheck source=.bash_aliases
    . ~/.bash_aliases
fi
