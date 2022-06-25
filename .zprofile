# shellcheck shell=bash source=./.zshrc

# Begin with a clear Path and set SHELL_ARCH env
eval "$(env -u PATH /usr/libexec/path_helper -s)"
SHELL_ARCH="$(arch)"
export SHELL_ARCH

# export XDG_CONFIG_HOME="$HOME/.config"
# export XDG_CACHE_HOME="$HOME/.caches"

eval "$(locale)"

# Initialize brew
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# add ESP-IDF Directory if it exists
if [[ -d "${HOME}/esp/esp-idf" ]]; then
  IDF_PATH="${HOME}/esp/esp-idf"
  ESPIDF="${IDF_PATH}"
  export IDF_PATH ESPIDF
fi

# init Pyenv
if [[ -d "$HOME/.pyenv" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# Dotnet Root
# export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
