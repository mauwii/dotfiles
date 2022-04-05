# Dotfiles

## Usage

The following Line is Part of the .zshrc file:

`alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'`

Now you can just use `config` instead of the `git` command to handle your Repository. f.E:

- `config fetch`
- `config pull`
- `config commit -a -m "This is my commit message"`

## Edit Scripts

I added a Directory which contains symlinks to the dotfiles I added to this Repository, so that it is easier to edit my Scripts via f.E. VSCode

`code ~/dotfiles`

## Original Tutorial

To create this Repo I used [this Tutorial](https://www.atlassian.com/git/tutorials/dotfiles)
