# shellcheck shell=bash source=/dev/null

# add ESP-IDF Directory if it exists
if [[ -d "${HOME}/esp/esp-idf" ]]; then
    IDF_PATH="${HOME}/esp/esp-idf"
    ESPIDF="$IDF_PATH"
    export IDF_PATH ESPIDF
fi

# brew bash completion@2
[[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] \
    && source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"

# load direnv hook to automatically load/unload .envrc files
[[ -x "$HOMEBREW_PREFIX/bin/direnv" ]] \
    && eval "$("$HOMEBREW_PREFIX/bin/direnv" hook bash)"

# brew command not found
HB_CNF_HANDLER="$HOMEBREW_PREFIX/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
[[ -f "$HB_CNF_HANDLER" ]] && source "$HB_CNF_HANDLER"

[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

# Initialize pyenv
if [[ -d "$HOME/.pyenv" ]]; then
    [[ -z "$PYENV_ROOT" ]] && export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin && $PATH != $PYENV_ROOT/bin* ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    # initialize pyenv-virtualenv
    [[ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" && "$PYENV_VIRTUALENV_INIT" -ne 1 ]] \
        && eval "$(pyenv virtualenv-init -)"
    # fix brew doctor's warning
#   if type brew &>/dev/null; then
#     alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
#   fi
fi
