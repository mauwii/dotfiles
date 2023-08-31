#!/usr/bin/env sh

# add shell functions
if [ -r "${HOME}/.functions" ]; then
    # shellcheck source=.functions
    . "${HOME}/.functions"
fi

if [ "${DOT_PROFILE}" = "true" ]; then
    debuglog "already loaded .profile"
    return
else
    debuglog "begin loading .profile"
fi

# set locale
[ -z "${LANG}" ] && eval "$(locale)"
[ -z "${LANG}" ] && export LANG=en_US.UTF-8
[ -z "${LC_ALL}" ] && export LC_ALL="${LANG}"

# set timezone
export TZ="${TZ-Europe/Berlin}"

# set command mode
export COMMAND_MODE="unix2003"

# OS variables
if [ "$(uname -s || true)" = "Darwin" ]; then
    export MACOS=1 UNIX=1
    debuglog "identified MACOS"
elif [ "$(uname -s || true)" = "Linux" ]; then
    export LINUX=1 UNIX=1
    debuglog "identified LINUX"
elif uname -s | grep -q "_NT-"; then
    export WINDOWS=1
    debuglog "identified WINDOWS"
elif grep -q "Microsoft" /proc/version 2>/dev/null; then
    export UBUNTU_ON_WINDOWS=1
    debuglog "identified UBUNTU_ON_WINDOWS"
fi

# add brew to env
if [ -x "/opt/homebrew/bin/brew" ]; then
    brew_init "/opt/homebrew"
elif [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    brew_init "/home/linuxbrew/.linuxbrew"
elif [ -x "/usr/local/bin/brew" ]; then
    brew_init "/usr/local"
fi

# add private bins to path
mkdir -p "${HOME}/.local/bin" && prepend_path "${HOME}/.local/bin"

# Add Ruby gems to PATH.
if validate_command ruby && validate_command gem; then
    __gems_path="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin"
    if [ -d "${__gems_path}" ]; then
        prepend_path "${__gems_path}"
    fi
    unset __gems_path
fi

# docker bins
if [ -d "${HOME}/.docker/bin" ]; then
    prepend_path "${HOME}/.docker/bin"
fi

# docker cli-plugins
if [ -d "${HOME}/.docker/cli-plugins" ]; then
    prepend_path "${HOME}/.docker/cli-plugins"
fi

# set PYENV_ROOT if dir exists and not set
if [ -d "${HOME}/.pyenv" ] && [ "${PYENV_ROOT-false}" != "false" ]; then
    export PYENV_ROOT"=${HOME}/.pyenv"
fi

# add pyenv bins to path if dir exists
if [ "${PYENV_ROOT-false}" != "false" ] && [ -d "${PYENV_ROOT}/bin" ]; then
    prepend_path "${PYENV_ROOT}/bin"
fi

# initialize pyenv
if validate_command pyenv; then
    # shellcheck disable=SC2312
    eval "$(pyenv init --path)"
    debuglog "initialized pyenv"
    if [ -d "${PYENV_ROOT}/plugins/pyenv-virtualenv/bin" ]; then
        prepend_path "${PYENV_ROOT}/plugins/pyenv-virtualenv/bin"
    fi
    if validate_command pyenv-virtualenv && [ "${PYENV_VIRTUALENV_INIT}" != 1 ]; then
        eval "$(pyenv virtualenv-init -)"
        debuglog "initialized pyenv-virtualenv"
    fi
fi

# set kubeconfig
if [ -r "${HOME}/.kube/config" ]; then
    export KUBECONFIG="${HOME}/.kube/config${KUBECONFIG:+:$KUBECONFIG}"
    debuglog "set KUBECONFIG to %s" "$KUBECONFIG"
fi

# set dotnet root if dir exists
DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
if [ -d "${DOTNET_ROOT}" ] && validate_command dotnet; then
    export DOTNET_ROOT
    debuglog "set DOTNET_ROOT to %s" "${DOTNET_ROOT}"
else
    unset DOTNET_ROOT
fi

# ensure docker completion
if validate_command docker && validate_command brew; then
    etc=/Applications/Docker.app/Contents/Resources/etc
    if [ -d $etc ] && [ -d "$(brew --prefix)/share/zsh/site-functions" ]; then
        ln -sf $etc/docker.bash-completion "$(brew --prefix)/etc/bash_completion.d/docker"
        ln -sf $etc/docker.zsh-completion "$(brew --prefix)/share/zsh/site-functions/_docker"
        if validate_command docker-compose && [ -d "$(brew --prefix)/etc/bash_completion.d" ]; then
            ln -sf $etc/docker-compose.bash-completion "$(brew --prefix)/etc/bash_completion.d/docker-compose"
            ln -sf $etc/docker-compose.zsh-completion "$(brew --prefix)/share/zsh/site-functions/_docker-compose"
        fi
    fi
fi

# # change docker socket
# DOCKER_HOST=${HOME}/.docker/run/docker.sock
# if [ -S "${DOCKER_HOST}" ] && [ ! -S /var/run/docker.socket ] \
#     && [ "$(docker context show || true)" = "default" ]; then
#     export DOCKER_HOST="unix://${DOCKER_HOST}"
#     debuglog "set DOCKER_HOST to %s" "${DOCKER_HOST}"
# else
#     unset DOCKER_HOST
# fi

# Count CPUs for Make jobs
if [ "${MACOS}" = 1 ]; then
    CPUCOUNT="$(sysctl -n hw.ncpu)"
elif [ "${LINUX}" = 1 ]; then
    CPUCOUNT="$(getconf _NPROCESSORS_ONLN)"
else
    CPUCOUNT=1
fi
if [ "${CPUCOUNT}" -gt 1 ]; then
    export MAKEFLAGS="-j${CPUCOUNT}"
    export BUNDLE_JOBS="${CPUCOUNT}"
fi

# remove read-only path "/usr/share/man" from MANPATH on MacOS
if validate_command manpath && [ "${MACOS}" = 1 ]; then
    MANPATH=$(manpath | sed 's#:\/usr\/share\/man:#:#g')
    debuglog "removed /usr/share/man from MANPATH"
    export MANPATH
fi

ENV="${HOME}/.shrc"

# shellcheck disable=SC2034
DOT_PROFILE="true"

debuglog "done loading .profile"
