# shellcheck shell=bash
# LC_ALL=en_US.UTF-8

# Begin with a clear Path and prepare brew env
eval "$(PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" /usr/libexec/path_helper -s)"
PROCTYPE="$(uname -m)"
export PROCTYPE

if [[ "$PROCTYPE" = "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi

# add ESP-IDF Directory if it exists
if [[ -d "${HOME}/esp/esp-idf" ]]; then
  IDF_PATH="${HOME}/esp/esp-idf"
  ESPIDF="${IDF_PATH}"
  export IDF_PATH ESPIDF
fi

# add my own binaries to path
PATH="$HOME/scripting/bin:$PATH"

# Add pyenv to front of path
# export PYENV_ROOT="$HOME/.pyenv"
# PATH="$PYENV_ROOT/bin:$PATH"
# export PATH
# eval "$(pyenv init --path)"
if which pyenv > /dev/null; then eval "$(pyenv init --path)"; fi
# if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

if [ "${BASH-no}" != "no" ]; then
	[ -r "$HOME/.bashrc" ] && . "$HOME/.bashrc"
fi
