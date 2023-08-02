# syntax=docker/dockerfile:1
FROM alpine:3.18

LABEL author="mauwii@outlook.de"
LABEL description="Docker image to verify my zsh related dotfiles"

# hadolint ignore=DL3018
RUN apk --no-cache add \
    bat \
    curl \
    direnv \
    exa \
    git \
    jq \
    nano \
    openssh-client-common \
    openssh-keygen \
    pandoc \
    starship \
    w3m \
    w3m-image \
    zsh

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Generate SSH Key and add it to the agent
RUN ssh-keygen -t ed25519 -C "root@dotfiles" -f ~/.ssh/id_ed25519 -N "" \
    && eval "$(ssh-agent -s)" \
    && ssh-add ~/.ssh/id_ed25519
