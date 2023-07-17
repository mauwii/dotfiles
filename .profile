# shellcheck shell=bash source=./.bashrc

# set locale
export LANG="en_US.UTF-8"
export LC_ALL='en_US.UTF-8'
eval "$(locale)"

# function to append fpath if dir exists
function __append_fpath() {
    local _fpath="$1"
    if [[ -d "${_fpath}" && $SHELL == *"zsh" ]]; then
        fpath+=("$_fpath")
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
    if [[ -f ~/.config/Brewfile ]]; then
        export HOMEBREW_BUNDLE_FILE=~/.config/Brewfile
    fi
    __append_fpath "${HOMEBREW_PREFIX}/share/zsh/site-functions"
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
if [[ -r "${HOME}/.kube/config" ]]; then
    KUBECONFIG="${HOME}/.kube/config${KUBECONFIG:+:$KUBECONFIG}"
    export KUBECONFIG
fi
