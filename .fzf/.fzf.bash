# shellcheck source=/dev/null
# Setup fzf
# ---------
fzfpath="${HOMEBREW_PREFIX}/opt/fzf/bin"
if [[ ! "$PATH" == *${fzfpath}* ]]; then
  export PATH="${PATH:+${PATH}:}${fzfpath}"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.bash"
