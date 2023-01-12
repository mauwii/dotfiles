# Begin with a clean path
# export MANPATH="$(env -i man --path)"
# export INFOPATH=""
eval "$(env -u PATH /usr/libexec/path_helper -s)"
export LANG="en_US.UTF-8"

# add brew to env
[[ -x /opt/homebrew/bin/brew ]] \
  && eval "$(/opt/homebrew/bin/brew shellenv)"

# Initialize pyenv
if [[ -d "${HOME}/.pyenv" || -n "${PYENV_ROOT}" ]]; then
  [[ -z "${PYENV_ROOT}" && -d "${HOME}/.pyenv" ]] && export PYENV_ROOT="${HOME}/.pyenv"
  [[ "$path" == *"${PYENV_ROOT}/bin"* ]] || path+=("${PYENV_ROOT}/bin")
  eval "$(pyenv init -)"
fi

export PIP_USE_PEP517
