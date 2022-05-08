# disable sourcing global dotfiles, located at /etc
# unsetopt globalrcs
export LANG="en_US"
export LC_COLLATE="en_US"
export LC_CTYPE="de_DE.UTF-8"
export LC_MESSAGES="de_DE"
export LC_MONETARY="de_DE"
export LC_NUMERIC="de_DE"
export LC_TIME="de_DE"

# create clean PATH
eval "$(env -i -P /usr/bin /usr/libexec/path_helper)"
SHELL_ARCH="$(arch)"
export SHELL_ARCH

# initialize brew
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ "${SHELL_ARCH}" == "i386" ]]; then
  export ARCHFLAGS='-arch x86_64'
  export DOCKER_DEFAULT_PLATFORM="linux/amd64"
elif [[ "${SHELL_ARCH}" == "arm64" ]]; then
  export DOCKER_DEFAULT_PLATFORM="linux/arm64"
  export ARCHFLAGS='-arch arm64 -arch x86_64'
fi

# Dotnet Root
export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"

# Remove dupilcates from manpath
typeset -U manpath

# add ESP-IDF if folder exists
if [[ -d $HOME/esp/esp-idf ]]; then
  IDF_PATH=$HOME/esp/esp-idf
  ESPIDF=$IDF_PATH
  export IDF_PATH ESPIDF
fi

# add my bins to front of path
path=(
  $HOME/scripting/bin
  $path
)
typeset -U path

fpath=(
  $HOMEBREW_PREFIX/share/zsh-completions
  $HOMEBREW_PREFIX/share/zsh/site-functions
  $HOME/scripting/zcompletions
  $fpath
)
typeset -U fpath

# Initialize Pyenv Path if pyenv is found
if which pyenv >/dev/null; then
  PYENV_ROOT="$HOME/.pyenv.${SHELL_ARCH}"
  export PYENV_ROOT
  eval "$(pyenv init --path)"
fi
