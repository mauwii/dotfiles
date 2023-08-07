#!/bin/sh
# shellcheck shell=sh

# add shell functions
if [ -r ~/.functions ] && [ "${DOT_FUNCTIONS:-false}" != "true" ]; then
    # shellcheck source=.functions
    . ~/.functions
fi

debuglog "loading .profile"

# set locale
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US:en"

# set timezone
export TZ="Europe/Berlin"

# set command mode
export COMMAND_MODE="unix2003"

# OS variables
[ "$(uname -s)" = "Darwin" ] && export MACOS=1 && export UNIX=1 \
    && debuglog "%s: identified MACOS" "${0##*/}"
[ "$(uname -s)" = "Linux" ] && export LINUX=1 && export UNIX=1 \
    && debuglog "%s: identified LINUX" "${0##*/}"
uname -s | grep -q "_NT-" && export WINDOWS=1 \
    && debuglog "%s: identified WINDOWS" "${0##*/}"
grep -q "Microsoft" /proc/version 2>/dev/null && export UBUNTU_ON_WINDOWS=1 \
    && debuglog "%s: identified UBUNTU_ON_WINDOWS" "${0##*/}"

# add brew to env
if [ -d "/opt/homebrew" ]; then
    brew_init "/opt/homebrew"
elif [ -d "/usr/local" ]; then
    brew_init "/usr/local"
fi

# add private bins to path
mkdir -p ~/.local/bin
prepend_path ~/.local/bin

# Add Ruby gems to PATH.
if validate_command ruby && validate_command gem; then
    gems_path="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin"
    if [ -d "${gems_path}" ]; then
        prepend_path "${gems_path}"
    fi
    unset gems_path
fi

# docker bins
if [ -d ~/.docker/bin ]; then
    prepend_path ~/.docker/bin
fi

# docker cli-plugins
if [ -d ~/.docker/cli-plugins ]; then
    prepend_path ~/.docker/cli-plugins
fi

# set PYENV_ROOT if dir exists and not set
if [ -d ~/.pyenv ] && [ -z "${PYENV_ROOT}" ]; then
    export PYENV_ROOT=~/.pyenv
fi

# add pyenv bins to path if dir exists
if [ -n "${PYENV_ROOT}" ] && [ -d "${PYENV_ROOT}/bin" ]; then
    prepend_path "${PYENV_ROOT}/bin"
fi

# initialize pyenv
if validate_command pyenv; then
    eval "$(pyenv init --path)"
    debuglog "%s: initialized pyenv" "${0##*/}"
fi

# set kubeconfig
if [ -r "${HOME}/.kube/config" ]; then
    export KUBECONFIG="${HOME}/.kube/config${KUBECONFIG:+:$KUBECONFIG}"
    debuglog ".profile: set KUBECONFIG to %s" "$KUBECONFIG"
fi

# set dotnet root if dir exists
DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
if [ -d "${DOTNET_ROOT}" ] && command -v dotnet >/dev/null 2>&1; then
    export DOTNET_ROOT
    debuglog ".profile: set DOTNET_ROOT to %s" "$DOTNET_ROOT"
else
    unset DOTNET_ROOT
fi

# change docker socket
DOCKER_HOST="$HOME/.docker/run/docker.sock"
if [ -S "$DOCKER_HOST" ] && [ ! -S /var/run/docker.socket ] \
    && [ "$(docker context show)" = "default" ]; then
    export DOCKER_HOST="unix://$DOCKER_HOST"
    debuglog ".profile: set DOCKER_HOST to %s" "$DOCKER_HOST"
else
    unset DOCKER_HOST
fi

# Count CPUs for Make jobs
if [ "${MACOS}" = "1" ]; then
    CPUCOUNT="$(sysctl -n hw.ncpu)"
elif [ "${LINUX}" = "1" ]; then
    CPUCOUNT="$(getconf _NPROCESSORS_ONLN)"
else
    CPUCOUNT=1
fi
if [ "${CPUCOUNT}" -gt 1 ]; then
    export MAKEFLAGS="${MAKEFLAGS:+$MAKEFLAGS }-j${CPUCOUNT}"
    export BUNDLE_JOBS="${CPUCOUNT}"
fi

# clean manpath
if validate_command manpath; then
    MANPATH="$(manpath)"
    if [ "$(uname -s)" = "Darwin" ]; then
        # remove read-only path "/usr/share/man" from MANPATH
        MANPATH=$(echo "${MANPATH}" | sed 's/:\/usr\/share\/man:/:/g')
        debuglog ".profile: removed /usr/share/man from MANPATH"
    fi
    export MANPATH
fi

# # source .shrc if interactive or login shell and not yet loaded
# case $- in
#     *"l"*)
#         shell_is="login"
#         ;;
#     *"i"*)
#         shell_is="interactive"
#         ;;
# esac
# if [ "${shell_is:-unset}" != "unset" ]; then
#     load_shrc="true"
#     debuglog "identified %s shell" "${shell_is}"
# fi
# if [ "${SHELL:-$0}" = /bin/sh -o "${SHELL:-$0}" = /bin/ash ] \
#     && [ "${load_shrc}" = "true" ] \
#     && [ -r ~/.shrc ] \
#     && [ "${DOT_SHRC:-false}" != "true" ]; then
#     # shellcheck source=.shrc
#     . ~/.shrc
# fi
# unset load_shrc shell_is

ENV=$HOME/.shrc

# shellcheck disable=SC2034
DOT_PROFILE="true"
