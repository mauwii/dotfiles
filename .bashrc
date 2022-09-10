# shellcheck shell=bash source=/dev/null

# add ESP-IDF Directory if it exists
if [[ -d "${HOME}/esp/esp-idf" ]]; then
  IDF_PATH="${HOME}/esp/esp-idf"
  ESPIDF="${IDF_PATH}"
  export IDF_PATH ESPIDF
fi

# brew bash completion@2
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# load direnv hook to automatically load/unload .envrc files
[[ -x "${HOMEBREW_PREFIX}/bin/direnv" ]] &&
  eval "$("${HOMEBREW_PREFIX}/bin/direnv" hook bash)"

if [[ -r "${HOMEBREW_PREFIX}/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh" ]]; then
  HB_CNF_HANDLER="${HOMEBREW_PREFIX}/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
fi
if [[ -f "$HB_CNF_HANDLER" ]]; then
  source "$HB_CNF_HANDLER"
fi

[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

# Initialize pyenv
if [[ -d "${HOME}/.pyenv" || -n "${PYENV_ROOT}" ]]; then
  [[ -z "${PYENV_ROOT}" && -d "${HOME}/.pyenv" ]] && export PYENV_ROOT="${HOME}/.pyenv"
  command -v pyenv &>/dev/null || path+="${PYENV_ROOT}/bin"
  eval "$(pyenv init -)"
  # initialize pyenv-virtualenv
  [[ -d "${PYENV_ROOT}/plugins/pyenv-virtualenv" && "${PYENV_VIRTUALENV_INIT}" -ne 1 ]] && eval "$(pyenv virtualenv-init -)"
  # fix brew doctor's warning
  if type brew &>/dev/null; then
    alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
  fi
fi
