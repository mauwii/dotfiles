# setup

Those are my dotfiles. Primary used on MacOS but I also want to use them in VMs,
Containers, ... Find the original docs [here](https://www.atlassian.com/git/tutorials/dotfiles)

## Locally

Here you can find some options about how to install the dotfiles locally and how to update them.

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

This is just a quick example, of course it works better in a prepared container (like your Dev Containers or Codespaces) where you already have `git` and `curl` installed.

The best option is if to create your own dotfiles, which you configure the way you need them :see_no_evil:

#### via script

```sh
docker run -it --rm --workdir=/root alpine:3.18 \
sh -c "wget -qO - https://bit.ly/baredotfiles | sh && sh -l"
```

#### mount cloned repo

This example asumes that you execute the command from within the cloned repo:

```sh
docker run --rm -it --workdir=/root -v $(pwd):/root/dotfiles debian \
sh -c "apt-get update && apt-get install -y exa nano pandoc w3m w3m-img \
&& sh dotfiles/.dotfiles/setup_local.sh && bash -l"
```

### Dockerfile

```Dockerfile
# syntax=docker/dockerfile:1
FROM debian:stable
...
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        exa \
        git \
        pandoc \
        w3m \
        w3m-img \
    && curl -Lks https://bit.ly/baredotfiles | /bin/bash \
    && rm -rf /var/lib/apt/lists/*
...
```
