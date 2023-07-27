#!/bin/sh
set -e

# check if bare repository already exists
if [ -d "${HOME}/.cfg" ]; then
    echo "bare repository already exists."
    exit 1
fi

# check if git is installed and try to install it if not
if ! command -v git >/dev/null 2>&1; then
    echo "git is not installed, will try to install it."
    if [ "$(uname -s)" = "Linux" ]; then
        if command -v apt-get >/dev/null 2>&1; then
            apt-get update
            apt-get install -y git
        elif command -v yum >/dev/null 2>&1; then
            yum update
            yum install -y git
        elif command -v pacman >/dev/null 2>&1; then
            pacman -Syu
            pacman -S --noconfirm git
        elif command -v apk >/dev/null 2>&1; then
            apk add git
        else
            echo "no package manager found, please install git first."
            exit 1
        fi
    elif [ "$(uname -s)" = "Darwin" ]; then
        if command -v brew >/dev/null 2>&1; then
            brew update
            brew install git
        else
            echo "brew is not installed, please install it first."
            exit 1
        fi
    else
        echo "unknown operating system, please install git first."
        exit 1
    fi
fi

cd "${HOME}" || exit 1
git clone --bare https://github.com/mauwii/dotfiles.git "${HOME}/.cfg"
config() {
    /usr/bin/git --git-dir="${HOME}/.cfg/" --work-tree="${HOME}" "${@}"
}
mkdir -p .config-backup
if [ "$(config checkout)" ]; then
    echo "Checked out config."
else
    echo "Backing up pre-existing dot files."
    config checkout 2>&1 \
        | grep -E "\s+\." \
        | awk '{print $1}' \
        | xargs -I{} mv {} .config-backup/{}
fi
if config checkout; then
    echo "Checked out config."
else
    echo "Failed to checkout config."
    exit 1
fi
config config status.showUntrackedFiles no
