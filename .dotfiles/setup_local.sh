#!/bin/sh

# cd to the directory of this script
SCRIPTDIR="$(dirname "${0}")"
cd "${SCRIPTDIR}/.." || exit 1

# copy files to home directory
for file in .??*; do
    # files to skip
    [ "$file" = ".git" ] \
        && echo "skipped .git" \
        && continue
    [ "$file" = ".DS_Store" ] \
        && echo "skipped .DS_Store" \
        && continue
    [ "$file" = ".gitignore" ] \
        && echo "skipped .gitignore" \
        && continue
    [ "$file" = ".gitmodules" ] \
        && echo "skipped .gitmodules" \
        && continue
    [ "$file" = ".dotfiles" ] \
        && echo "skipped .dotfiles" \
        && continue
    # copy file if not skipped
    cp -R "$file" "$HOME"
done

ln -s .config/zsh/.zshenv "${HOME}/.zshenv"
