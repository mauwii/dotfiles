# setup

Those are my dotfiles. Primary used on MacOS but I also want to use them in VMs,
Containers, ...

Find the original docs [here](https://www.atlassian.com/git/tutorials/dotfiles)

Here are some options how you can set them up:

## Locally

### MacOS

Since this is my main OS I will just start with it :trollface:

#### prereqs

1. xcode commandline tools (comes with git, curl and ofc. much more):

   `sudo xcode-select --install`

2. brew (optional but I'm sure you rly want this package manager :wink: )

   ```zsh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

#### Setup script

One way is to directly execute the setup script. This will clone the bare repo
into your home directory (`${HOME}/.cfg`):

```zsh
curl -Lks https://bit.ly/baredotfiles | /bin/bash
```

#### Manual

```zsh
git clone --bare https://github.com/mauwii/dotfiles.git "${HOME}/.cfg"
```

### how to use

I create an alias named `config`, which can be used as if you would use `git`. Some example commands:

- `config status`
- `config add <filename> [<filename> ...]`
- `config commit - m "Your commit message"`
- `config push`
- `config pull`
- ...

## Docker

### Quick example

This is just a quick example, of course it works better in a prepared container (like your Dev Containers or Codespaces) where you already have `git` and `curl` installed:

```sh
docker run -it --rm alpine --workdir=/root \
sh -c "wget -qO - https://bit.ly/baredotfiles | sh && sh -l"
```

It works best if you create your own dotfiles which you configure the way you need :see_no_evil:

### Dockerfile

```Dockerfile
# syntax=docker/dockerfile:1
FROM debian:stable
...
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        curl \
    && curl -Lks https://bit.ly/baredotfiles | /bin/bash \
    && rm -rf /var/lib/apt/lists/*
...
```
