# shellcheck shell=sh

# check if this scritp was sourced
if [[ "$-" != *"i"* ]]; then
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
alias l='ls -a -h'
alias ll='l -l -g'
alias lll='ll -@'
alias lr='ls -R'
alias llr='lr -l'

# replace cat with bat, but disable paging to make it behave like cat
if command -v bat >/dev/null 2>&1; then
    alias cat="bat --paging=never"
fi

# dotfiles management
if [[ -d "${HOME}/.cfg" ]] && command -v /usr/bin/git >/dev/null 2>&1; then
    alias config="command git --git-dir=\"${HOME}/.cfg\" --work-tree=\"${HOME}\""
fi
if command -v config >/dev/null 2>&1; then
    # link all files to ~/.dotfiles to open in code
    function link-dotfiles() {
        cd "${HOME}" || return 1
        for file in $(config ls-tree --full-tree -r --name-only HEAD); do
            # skip .dotfiles folder
            if [[ "${file}" =~ .dotfiles ]]; then
                continue
            fi
            local _path="${HOME}/.dotfiles/${file}"
            mkdir -p "${_path%/*}"
            ln -sf "${HOME}/${file}" "${_path}"
        done
    }
    # open ~/.dotfiles in code
    if command -v code >/dev/null 2>&1; then
        alias dotfiles='link-dotfiles && code ~/.dotfiles'
    fi
fi

# Copy public SSH Key
if command -v pbcopy >/dev/null 2>&1; then
    alias pubkey='pbcopy < ${HOME}/.ssh/id_ed25519.pub'
fi

# dump Brewfile
if [ -n "${HOMEBREW_BUNDLE_FILE}" ]; then
    alias dump-brewfile='brew bundle dump --file="${HOMEBREW_BUNDLE_FILE}" --force'
fi

# install or match Brewfile (match removes everything whats not in the Brewfile)
if [ -f "${HOMEBREW_BUNDLE_FILE}" ]; then
    alias install-brewfile='brew bundle --file="${HOMEBREW_BUNDLE_FILE}"'
    alias match-brewfile='brew bundle --force cleanup --file="${HOMEBREW_BUNDLE_FILE}"'
fi
