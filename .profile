# shellcheck shell=sh

# add shell functions
if [ -r ~/.functions ]; then
    # shellcheck source=.functions
    . ~/.functions
fi

debuglog "loading .profile"

# set locale
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
# export LANGUAGE="en_US.UTF-8"
# eval "$(locale)"

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

# Add Ruby gems to PATH.
if command -v ruby >/dev/null 2>&1 && command -v gem >/dev/null 2>&1; then
    prepend_path "$(ruby -r rubygems -e 'puts Gem.user_dir')/bin"
fi

# docker bins
if [ -d "$HOME/.docker/bin" ]; then
    prepend_path "$HOME/.docker/bin"
fi

# docker cli-plugins
if [ -d "$HOME/.docker/cli-plugins" ]; then
    prepend_path "$HOME/.docker/cli-plugins"
fi

# personal bins
mkdir -p ~/.local/bin
prepend_path "$HOME/.local/bin"

# set PYENV_ROOT if dir exists and not set
if [ -d ~/.pyenv ] && [ -z "${PYENV_ROOT}" ]; then
    export PYENV_ROOT=~/.pyenv
fi

# add pyenv bins to path if dir exists
if [ -d "${PYENV_ROOT}/bin" ]; then
    prepend_path "${PYENV_ROOT}/bin"
fi

# initialize pyenv
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init --path)"
    debuglog "%s: initialized pyenv" "${0##*/}"
fi

# set kubeconfig
if [ -r "${HOME}/.kube/config" ]; then
    export KUBECONFIG="${HOME}/.kube/config${KUBECONFIG:+:$KUBECONFIG}"
    debuglog "%s: set KUBECONFIG to %s" "${0##*/}" "$KUBECONFIG"
fi

# set dotnet root if dir exists
DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
if [ -d "${DOTNET_ROOT}" ] && command -v dotnet >/dev/null 2>&1; then
    export DOTNET_ROOT
    debuglog "%s: set DOTNET_ROOT to %s" "${0##*/}" "$DOTNET_ROOT"
else
    unset DOTNET_ROOT
fi

# change docker socket
DOCKER_HOST="$HOME/.docker/run/docker.sock"
if [ -S "$DOCKER_HOST" ] && [ ! -S /var/run/docker.socket ] \
    && [ "$(docker context show)" = "default" ]; then
    export DOCKER_HOST="unix://$DOCKER_HOST"
    debuglog "%s: set DOCKER_HOST to %s" "${0##*/}" "$DOCKER_HOST"
else
    unset DOCKER_HOST
fi

# Count CPUs for Make jobs
if [ "${MACOS}" ]; then
    CPUCOUNT="$(sysctl -n hw.ncpu)"
elif [ "${LINUX}" ]; then
    CPUCOUNT="$(getconf _NPROCESSORS_ONLN)"
else
    CPUCOUNT=1
fi
if [ "${CPUCOUNT}" -gt 1 ]; then
    export MAKEFLAGS="${MAKEFLAGS:+$MAKEFLAGS }-j${CPUCOUNT}"
    export BUNDLE_JOBS="${CPUCOUNT}"
fi

# clean manpath
if command -v manpath >/dev/null 2>&1; then
    MANPATH="$(manpath)"
    if [ "$(uname -s)" = "Darwin" ]; then
        # remove read-only path "/usr/share/man" from MANPATH
        MANPATH="${MANPATH//:\/usr\/share\/man:/}"
        debuglog "%s: removed /usr/share/man from MANPATH" "${0##*/}"
        # MANPATH="$(echo "$MANPATH" | sed -e 's#:\/usr\/share\/man:#:#g')"
    fi
    export MANPATH
fi

# source .shrc if interactive or login shell and not yet loaded
case $- in
    *"l"*)
        SHELL_IS="login"
        return
        ;;
    *"i"*) SHELL_IS="interactive" ;;
esac
if [ "${SHELL_IS:-unset}" != "unset" ]; then
    LOAD_SHRC="true"
    debuglog "%s: identified %s shell" "${0##*/}" "${SHELL_IS}"
fi
if [ "${LOAD_SHRC:-false}" = "true" ] \
    && [ "${SHELL:-$0}" = /bin/sh ] \
    && [ -r ~/.shrc ] \
    && [ "${DOT_SHRC:-false}" != "true" ]; then
    # shellcheck source=.shrc
    . ~/.shrc
fi
unset LOAD_SHRC SHELL_IS

# shellcheck disable=SC2034
DOT_PROFILE="true"
