# shellcheck shell=bash source=./.bash_profile

# ARCHFLAGS='-arch arm64 -arch x86_64'
# export ARCHFLAGS

# Warn if Arch changed
if [[ "${SHELL_ARCH}" != "$(arch)" ]]; then
  echo "Be Careful - yor architecture changed so your env is likely to be messed up!!!"
fi

# shellcheck disable=SC2167
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
# for bcfile in "${HOMEBREW_PREFIX}"/etc/bash_completion.d/*; do
#     source "${bcfile}"
# done

if [[ "$SHELL_ARCH" = "arm64" ]]; then
  alias rosettaterm="arch -arch x86_64 /bin/bash -l"
fi

# load direnv hook to automatically load/unload .envrc files
[[ -x "${HOMEBREW_PREFIX}/bin/direnv" ]] &&
  eval "$("${HOMEBREW_PREFIX}/bin/direnv" hook bash)"

if [[ -r "${HOMEBREW_PREFIX}/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh" ]]; then
  HB_CNF_HANDLER="${HOMEBREW_PREFIX}/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
fi
if [[ -f "$HB_CNF_HANDLER" ]]; then
  source "$HB_CNF_HANDLER"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
