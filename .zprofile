# disable sourcing global dotfiles, located at /etc
# unsetopt globalrcs
# export LC_ALL=en_US.UTF-8

# create clean PATH
eval "$(env -i -P/usr/bin /usr/libexec/path_helper)"
SHELL_ARCH="$(arch)"
export SHELL_ARCH

# initialize arch-dependend brew env
if [[ "$SHELL_ARCH" == "arm64" ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  if [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# If Brewfile.<arch> exists, use brew bundle to install packages
# if which brew &>/dev/null && [[ -s "${HOME}/Brewfile.${SHELL_ARCH}" ]]; then
#   brew bundle install --file="${HOME}/Brewfile.${SHELL_ARCH}"
# fi

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
# export path

fpath=(
  /usr/share/zsh/5.8/functions
  $HOMEBREW_PREFIX/share/zsh-completions
  $HOMEBREW_PREFIX/share/zsh/site-functions
  $HOME/scripting/zcompletions
  ${fpath[@]}
)
typeset -U fpath

# Initialize Pyenv Path if pyenv is found
if which pyenv >/dev/null; then
  PYENV_ROOT="$HOME/.pyenv.${SHELL_ARCH}"
  export PYENV_ROOT
  eval "$(pyenv init --path)"
fi
