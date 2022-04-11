# Dotfiles

## Usage

This Line should be contained in your RC file (f.E `~/.zshrc` or/and `~/.bashrc`):

```sh
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

Now you can just use `config` to handle your Repository. Here are some examples:

| Command                                  | Purpose                      |
| :--------------------------------------- | :--------------------------- |
| `config add <path/to/file[s]>`           | Adds file\[s\] to repository |
| `config commit -a -m "<commit message>"` | commit changes               |
| `config pull`                            | update local dotfiles        |

```bash
config status
config add .vimrc
config commit -m "Add vimrc"
config add .bashrc
config commit -m "Add bashrc"
config push
```

## Edit Scripts

I added a Directory with symlinks to the dotfiles which where added to this Repository, so that it is easier to edit my Scripts via f.E. VSCode

`code ~/dotfiles`

### Code-Workspace

I started to experiment with a Code-Workspace File as well, to open other Folders as well, which makes looking at Configurations more easy for me. To open it, just use:

`open ~/dotfiles.code-workspace`

## Original Tutorial

To create this Repo I used [this Tutorial](https://www.atlassian.com/git/tutorials/dotfiles)
