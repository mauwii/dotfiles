# Setup fzf
# ---------
fzfpath="/opt/homebrew/opt/fzf/bin"
if [[ ! "$PATH" == *${fzfpath}* ]]; then
  export PATH="${PATH:+${PATH}:}${fzfpath}"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.zsh"
