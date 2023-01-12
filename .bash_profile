# shellcheck shell=bash source=./.bashrc

# Begin with a clean path
eval "$(env -u PATH /usr/libexec/path_helper -s)"
export LANG="en_US.UTF-8"

# add brew to env
[[ -x /opt/homebrew/bin/brew ]] \
  && eval "$(/opt/homebrew/bin/brew shellenv)"

# Initialize pyenv
if [[ -d "${HOME}/.pyenv" || -n "${PYENV_ROOT}" ]]; then
  [[ -z "${PYENV_ROOT}" && -d "${HOME}/.pyenv" ]] && export PYENV_ROOT="${HOME}/.pyenv"
  [[ "$PATH" == *"${PYENV_ROOT}/bin"* ]] || export PATH="${PYENV_ROOT}/bin:$PATH"
  eval "$(pyenv init -)"
fi
