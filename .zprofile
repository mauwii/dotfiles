# set language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Begin with a clean path
if [[ -x /usr/libexec/path_helper ]]; then
    eval $(/usr/libexec/path_helper -s)
else
    export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
fi

# personal bins
PERSONAL_BIN="$HOME/.local/bin"
if [ -d "${PERSONAL_BIN}" ]; then
    export PATH="$PERSONAL_BIN${PATH:+:$PATH}"
fi

# # clean manpath
unset MANPATH
MANPATH="$(manpath)"
export MANPATH

# add brew to env
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval $(/opt/homebrew/bin/brew shellenv)
    export HOMEBREW_BUNDLE_FILE=~/.config/Brewfile
    HOMEBREW_ZCOMP="${HOMEBREW_PREFIX}/share/zsh-completions"
    if [[ -d "${HOMEBREW_ZCOMP}" && "${FPATH}" != *"${HOMEBREW_ZCOMP}"* ]]; then
        fpath+=("${HOMEBREW_ZCOMP}")
    fi
    unset HOMEWREW_ZCOMP
    HOMEBREW_ZFUNC="${HOMEBREW_PREFIX}/share/zsh/site-functions"
    if [[ -d "${HOMEBREW_ZFUNC}" && "${FPATH}" != *"${HOMEBREW_ZFUNC}"* ]]; then
        fpath+=("${HOMEBREW_ZFUNC}")
    fi
    unset HOMEBREW_ZFUNC
fi

# private docker bins
DOCKER_BIN="$HOME/.docker/bin"
if [[ -d "${DOCKER_BIN}" && "${PATH}" != *"$DOCKER_BIN"* ]]; then
    export PATH="$DOCKER_BIN${PATH+:$PATH}"
fi
unset DOCKER_BIN

# initialize pyenv path
if [[ -d "${HOME}/.pyenv" && -z "${PYENV_ROOT}" ]]; then
    export PYENV_ROOT="${HOME}/.pyenv"
fi
if [[ -d "${PYENV_ROOT}/bin" && "${PATH}" != *"${PYENV_ROOT}/bin"* ]]; then
    export PATH="${PYENV_ROOT}/bin${PATH+:$PATH}"
fi
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
