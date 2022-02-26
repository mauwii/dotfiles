# disable sourcing global dotfiles, located at /etc
# unsetopt globalrcs
# LC_ALL=C.UTF-8

# create clean PATH
eval "$(PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" /usr/libexec/path_helper -s)"
PROCTYPE="$(uname -m)"

# initialize arch-dependend brew env
if [[ "$PROCTYPE" == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi

# add ESP-IDF if folder exists
if [[ -d $HOME/esp/esp-idf ]]; then
  IDF_PATH=$HOME/esp/esp-idf
  ESPIDF=$IDF_PATH
  export IDF_PATH ESPIDF
fi

fpath=(
  "$(brew --prefix)/share/zsh-completions"
  "$(brew --prefix)/share/zsh/site-functions"
  "/usr/share/zsh/5.8/functions"
)
  # "$HOME/scripting/zcompletions"

# add my bins to front of path
path=(
  $HOME/scripting/bin
  $path
)

# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init --path)"
if which pyenv > /dev/null; then eval "$(pyenv init --path)"; fi
# if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Remove dupilcates from paths
typeset -U path fpath manpath
export PATH FPATH MANPATH PROCTYPE
