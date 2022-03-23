# disable sourcing global dotfiles, located at /etc
unsetopt globalrcs

# create clean PATH
eval "$(PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" /usr/libexec/path_helper -s)"
PROCTYPE="$(uname -m)"
export PROCTYPE

# initialize arch-dependend brew env
if [[ "$PROCTYPE" == "arm64"  ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  if [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

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
export path

fpath=(
  /usr/share/zsh/5.8/functions
  $(brew --prefix)/share/zsh-completions
  $(brew --prefix)/share/zsh/site-functions
  $fpath
)
export fpath
  # "$HOME/scripting/zcompletions"

# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init --path)"
if which pyenv > /dev/null; then eval "$(pyenv init --path)"; fi
# if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Remove dupilcates from path, fpath and manpath
typeset -U path fpath manpath
