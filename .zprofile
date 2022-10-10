# Begin with a clean env
# export MANPATH="$(env -i man --path)"
# export INFOPATH=""
eval "$(env -u PATH /usr/libexec/path_helper -s)"
export LANG="en_US.UTF-8"
# export XDG_CONFIG_HOME="${HOME}/.config"
# export XDG_CACHE_HOME="${HOME}/.caches"

# add brew to env
[[ -x /opt/homebrew/bin/brew ]] \
  && eval "$(/opt/homebrew/bin/brew shellenv)" \
  && export CPPFLAGS="-I/opt/homebrew/include" \
  && export LDFLAGS="-L/opt/homebrew/lib"

# Initialize pyenv
if [[ -d "${HOME}/.pyenv" || -n "${PYENV_ROOT}" ]]; then
  [[ -z "${PYENV_ROOT}" && -d "${HOME}/.pyenv" ]] && export PYENV_ROOT="${HOME}/.pyenv"
  [[ $commands[pyenv] ]] || path+="${PYENV_ROOT}/bin"
  eval "$(pyenv init -)"
fi
