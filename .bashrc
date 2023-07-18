# shellcheck shell=bash source=/dev/null

# chck if this is a interactive shell
if [ -z "$PS1" ]; then
    return
fi

# source bash_prompt
if [ -f ~/.bash_prompt ]; then
    . ~/.bash_prompt
fi

# add ESP-IDF Directory if it exists
IDF_PATH=~/esp/esp-idf
if [ -f "${IDF_PATH}/export.sh" ]; then
    export ESPIDF="${IDF_PATH}"
    alias getidf='. ${ESPIDF}/export.sh'
else
    unset IDF_PATH
fi

# direnv hook to automatically load/unload .envrc files
if which -s direnv; then eval "$(direnv hook bash)"; fi

# dotfiles management
if [ -d "${HOME}/.cfg" ] && command -v git >/dev/null 2>&1; then
    alias config='git --git-dir=${HOME}/.cfg/ --work-tree=${HOME}'
fi
# link all files to ~/.dotfiles to open in code
if command -v config >/dev/null 2>&1; then
    function link-dotfiles() {
        for file in $(config ls-tree --full-tree -r --name-only HEAD); do
            local _path="${HOME}/.dotfiles/${file}"
            mkdir -p "${_path%/*}"
            ln -sf "${HOME}/${file}" "${HOME}/.dotfiles/${file}"
        done
    }
fi

# Initialize pyenv
if [ -d ~/.pyenv ] && [ -z "$PYENV_ROOT" ]; then
    export PYENV_ROOT=~/.pyenv
fi

if [ -d "$PYENV_ROOT/bin" ]; then
    if echo "$PATH" | grep -q "$PYENV_ROOT/bin"; then
        export PATH="$PYENV_ROOT/bin:${PATH//${PYENV_ROOT}\/bin/}"
    fi
fi
if which -s pyenv; then eval "$(pyenv init -)"; fi
if which -s pyenv-virtualenv && [ "$PYENV_VIRTUALENV_INIT" != 1 ]; then
    eval "$(pyenv virtualenv-init -)"
fi

alias ls="ls --color=auto"
alias l="ls -a -h"
alias ll="l -l -g"
alias lll="ll -@"
alias lr="ls -R"
alias llr="lr -l"

# replace cat with bat, but disable paging to make it behave like cat
if which -s bat; then
    alias cat="bat --paging=never"
fi

# pipx completion
if command -v pipx >/dev/null 2>&1; then
    eval "$(register-python-argcomplete pipx)"
fi

# brew completion
if [ -d "$HOMEBREW_PREFIX" ]; then
    if [ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
        . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
    else
        for completionscript in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
            [ -r "${completionscript}" ] && . "$completionscript"
        done
    fi
fi
