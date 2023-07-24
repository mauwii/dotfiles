# shellcheck shell=bash

# check if this scritp was sourced
if [ "$0" = "${BASH_SOURCE[0]}" ]; then
    echo "Error: Script must be sourced"
    exit 1
fi

# use exa as modern ls-replacement if available
if command -v exa >/dev/null 2>&1; then
    alias ls='exa --icons --group-directories-first --git --accessed --modified --created'
else
    alias ls='ls -G'
fi

# ls aliases
alias l="ls -a -h"
alias ll='l -l -g'
alias lll="ll -@"
alias lr="ls -R"
alias llr="lr -l"

# replace cat with bat, but disable paging to make it behave like cat
if command -v bat >/dev/null 2>&1; then
    alias cat="bat --paging=never"
fi

# dotfiles management
if [ -d "${HOME}/.cfg" ] && command -v /usr/bin/git >/dev/null 2>&1; then
    alias config='git --git-dir ${HOME}/.cfg/ --work-tree ${HOME}'
fi

if alias config >/dev/null 2>&1; then
    # link all files to ~/.dotfiles to open in code
    function link-dotfiles() {
        for file in $(config ls-tree --full-tree -r --name-only HEAD); do
            local _path="${HOME}/.dotfiles/${file}"
            mkdir -p "${_path%/*}"
            ln -sf "${HOME}/${file}" "${HOME}/.dotfiles/${file}"
        done
    }
    # open ~/.dotfiles in code
    if command -v code >/dev/null 2>&1; then
        alias dotfiles='link-dotfiles && code ~/.dotfiles'
    fi
fi
