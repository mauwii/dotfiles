# Begin with a clean path
eval "$(env -u PATH /usr/libexec/path_helper -s)"
export LANG=en_US.UTF-8

# add brew to env
[[ -x /opt/homebrew/bin/brew ]] \
    && eval "$(/opt/homebrew/bin/brew shellenv)"

[[ -d ~/.pyenv && -x "$(which pyenv)" ]] \
    && export PYENV_ROOT=~/.pyenv
[[ -n "$PYENV_ROOT" ]] && eval "$(pyenv init -)"
