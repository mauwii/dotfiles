# shellcheck shell=bash source=./.bashrc

# Begin with a clean path
eval "$(env -u PATH /usr/libexec/path_helper -s)"
export LANG="en_US.UTF-8"

# add brew to env
[[ -x /opt/homebrew/bin/brew ]] \
  && eval "$(/opt/homebrew/bin/brew shellenv)"

# add pyenv to path if available
[[ -d ~/.pyenv ]] && export PYENV_ROOT=~/.pyenv
[[ -x $(which pyenv) ]] && eval "$(pyenv init --path)"
