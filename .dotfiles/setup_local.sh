#!/bin/sh

# cd to the directory of this script
SCRIPTDIR="$(dirname "$0")"
cd "$SCRIPTDIR"/.. || exit 1

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
    [ "$file" = ".editorconfig" ] \
        && echo "skipped .editorconfig" \
        && continue
    [ "$file" = ".local" ] \
        && echo "skipped .local" \
        && continue
    [ "$file" = ".dotfiles" ] \
        && echo "skipped .dotfiles" \
        && continue
    [ "$file" = ".gitconfig.local" ] \
        && echo "skipped .gitconfig" \
        && continue
    # copy file if not skipped
    cp -r "$file" "$HOME"
done
