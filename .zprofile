# set language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# function to append fpath if dir exists
function __append_fpath() {
    local _fpath="$1"
    # if [[ -d "${_fpath}" && $FPATH!=*"${_fpath}"* ]]; then
    if [[ -d "${_fpath}" ]]; then
        fpath+=("${_fpath}")
    fi
}

# function to prepend path if dir exists
function __prepend_path() {
    local _path="$1"
    if [[ -d "${_path}" ]]; then
        # PATH="${_path}${PATH:+:$PATH}"
        path=($_path $path)
    fi
}

# Begin with a clean path
if [[ -x /usr/libexec/path_helper ]]; then
    eval $(/usr/libexec/path_helper -s)
else
    export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
fi

# clean manpath
MANPATH="$(manpath)"

# add brew to env
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval $(/opt/homebrew/bin/brew shellenv)
    if [[ -f ~/.config/Brewfile ]]; then
        export HOMEBREW_BUNDLE_FILE=~/.config/Brewfile
    fi
    __append_fpath "${HOMEBREW_PREFIX}/share/zsh-completions"
    __append_fpath "${HOMEBREW_PREFIX}/share/zsh/site-functions"
fi

# docker bins
__prepend_path "${HOME}/.docker/bin"

# docker cli-plugins
__prepend_path "${HOME}/.docker/cli-plugins"

# personal bins
__prepend_path "${HOME}/.local/bin"

# set PYENV_ROOT if dir exists
if [[ -d "${HOME}/.pyenv" && -z "${PYENV_ROOT}" ]]; then
    export PYENV_ROOT="${HOME}/.pyenv"
fi

# add pyenv bins to path if dir exists
__prepend_path "${PYENV_ROOT}/bin"

# initialize pyenv path
if [ -x $(which -p pyenv) ]; then
    eval "$(pyenv init --path)"
fi

# set kubeconfig
if [[ -r "${HOME}/.kube/config" ]]; then
    KUBECONFIG="${HOME}/.kube/config${KUBECONFIG:+:$KUBECONFIG}"
    export KUBECONFIG
fi

# set completion dump file
_comp_dumpfile="${ZDOTDIR:-$HOME}/.zcompdump-$(hostname -s)-${ZSH_VERSION}"
export ZSH_COMPDUMP="${_comp_dumpfile}"
