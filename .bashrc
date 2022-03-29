# shellcheck shell=bash source=./.bash_profile

# Clear Path if arch changed and prepare brew env
if [[ "$PROCTYPE" != $(uname -m) ]]; then
  echo "detected architecture change, creating new env"
  source "$HOME/.bash_profile"
fi

if [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]]; then
  source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
fi

for bcfile in "$HOMEBREW_PREFIX"/etc/bash_completion.d/* ; do
  . "$bcfile"
done

if [[ "$PROCTYPE" = "arm64" ]]; then
  alias rosettaterm="arch -arch x86_64 /bin/bash -l"
fi

if [[ $(which topgrade) > /dev/null ]]; then
  alias topgrade="topgrade --disable=pip3"
fi

# load direnv hook to automatically load/unload .envrc files
[[ -x "${HOMEBREW_PREFIX}/bin/direnv" ]] && \
  eval "$("${HOMEBREW_PREFIX}/bin/direnv" hook bash)"

if [[ -d "${HOME}/.nvm" ]]; then
  export NVM_DIR="${HOME}/.nvm"
  [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"                   # This loads nvm
  [ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion" # This loads nvm bash_completion
fi

# add pyenv shims to front of path and inizialize pyenv
if which pyenv > /dev/null; then
  eval "$(pyenv init -)"
  # initialize pyenv-virtualenv
  if which pyenv-virtualenv-init > /dev/null; then
    eval "$(pyenv virtualenv-init -)"
  fi
  # remove pyenv from PATH when executing brew
  if which brew > /dev/null; then
    alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
  fi
fi

HB_CNF_HANDLER="$(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
if [ -f "$HB_CNF_HANDLER" ]; then
  source "$HB_CNF_HANDLER";
fi
