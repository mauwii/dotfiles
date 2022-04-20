# Dotfiles

## Usage

### add alias

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

### Edit Scripts

Clone repository to have a centralized place where you can edit your dotfiles like

```sh
code path/to/dotfiles
```

after you pushed the repository, you need to update your local files with

```sh
config pull
```

## Original Tutorial

To create this Repo I used [this Tutorial](https://www.atlassian.com/git/tutorials/dotfiles)
