# shellcheck shell=bash source=./.bash_profile

ARCHFLAGS='-arch arm64 -arch x86_64'
export ARCHFLAGS

# Warn if Arch changed
if [[ "${SHELL_ARCH}" != "$(arch)" ]]; then
  echo "Be Careful - yor architecture changed so your env is likely to be messed up!!!"
fi

if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
  source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
fi

for bcfile in "${HOMEBREW_PREFIX}/etc/bash_completion.d"/*; do
  source "$bcfile"
done

if [[ "$SHELL_ARCH" = "arm64" ]]; then
  alias rosettaterm="arch -arch x86_64 /bin/bash -l"
fi

# load direnv hook to automatically load/unload .envrc files
[[ -x "${HOMEBREW_PREFIX}/bin/direnv" ]] &&
  eval "$("${HOMEBREW_PREFIX}/bin/direnv" hook bash)"

# initialize brewed node version manager
if [[ -d "${HOME}/.nvm.${SHELL_ARCH}" ]]; then
  NVM_DIR="${HOME}/.nvm.${SHELL_ARCH}"
  export NVM_DIR
  # This loads nvm
  if [[ -s "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" ]]; then
    source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"
  fi
  # This loads nvm bash_completion
  if [[ -s "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm" ]]; then
    source "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm"
  fi
  nvm use --lts >/dev/null
fi

# add pyenv shims to front of path and inizialize pyenv
if which pyenv >/dev/null; then
  eval "$(pyenv init -)"
  # initialize pyenv-virtualenv
  if [[ $(which pyenv-virtualenv-init) > /dev/null ]]; then
    eval "$(pyenv virtualenv-init -)"
  fi
  # remove pyenv from PATH when executing brew
  if which brew >/dev/null; then
    alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
  fi
fi

if [[ -r "${HOMEBREW_PREFIX}/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh" ]]; then
  HB_CNF_HANDLER="${HOMEBREW_PREFIX}/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
fi
if [[ -f "$HB_CNF_HANDLER" ]]; then
  source "$HB_CNF_HANDLER"
fi

# If System is MacOS, start ssh-agent and add keys from keychain
if [[ $(uname -s) = "Darwin" ]]; then
  ssh-agent &>/dev/null
  ssh-add --apple-load-keychain &>/dev/null
fi
