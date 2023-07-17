# shellcheck shell=bash

# set locale
export LANG="en_US.UTF-8"
export LC_ALL='en_US.UTF-8'
eval "$(locale)"

# function to append fpath if dir exists
function __prepend_fpath() {
    local _fpath="$1"
    if [[ -d "${_fpath}" && $SHELL == *"zsh" ]]; then
        export FPATH="${_fpath}${FPATH+:${FPATH//${_fpath}:/}}"
    fi
}

# function to prepend path if dir exists
function __prepend_path() {
    local _path="$1"
    if [[ -d "${_path}" ]]; then
        export PATH="${_path}:${PATH//${_path}:/}"
    fi
}

# add brew to env
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    HOMEBREW_BUNDLE_FILE=~/.config/Brewfile
    if [[ -f $HOMEBREW_BUNDLE_FILE ]]; then
        export HOMEBREW_BUNDLE_FILE
    else
        unset HOMEBREW_BUNDLE_FILE
    fi
    __prepend_fpath "$(brew --prefix)/share/zsh/site-functions"
fi

# docker bins
__prepend_path ~/.docker/bin

# docker cli-plugins
__prepend_path ~/.docker/cli-plugins

# personal bins
__prepend_path ~/.local/bin

# set PYENV_ROOT if dir exists and not set
if [[ -d "${HOME}/.pyenv" && -z "${PYENV_ROOT}" ]]; then
    export PYENV_ROOT="${HOME}/.pyenv"
fi

# add pyenv bins to path if dir exists
__prepend_path "${PYENV_ROOT}/bin"

# initialize pyenv path
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init --path)"
fi

# set kubeconfig
_local_kubeconfig="${HOME}/.kube/config.local"
if [[ -r "${_local_kubeconfig}" ]]; then
    KUBECONFIG="${_local_kubeconfig}${KUBECONFIG:+:$KUBECONFIG}"
    export KUBECONFIG
fi
unset _local_kubeconfig

# set dotnet root if dir exists
DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
if [[ -d "${DOTNET_ROOT}" ]]; then
    export DOTNET_ROOT
else
    unset DOTNET_ROOT
fi

# clean manpath
if command -v manpath >/dev/null 2>&1; then
    MANPATH=$(manpath)
    if [[ $(uname -s) == Darwin ]]; then
        # replace ":/usr/share/man:" with ":" in MANPATH
        # since /usr/share/man is readonly and a whatis file cannot be created there
        export MANPATH=${MANPATH//:\/usr\/share\/man:/:}
    else
        export MANPATH
    fi
fi
