# syntax=docker/dockerfile:1
FROM ubuntu:22.04

LABEL \
    author="mauwii@outlook.de" \
    description="Docker image to debug my dotfiles"

# Enable pipefail
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install dependencies
# hadolint ignore=DL3008
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        bat \
        build-essential \
        curl ca-certificates \
        direnv \
        exa \
        git \
        jq \
        locales tzdata \
        nano \
        openssh-client \
        pipx \
        pandoc w3m w3m-img \
        zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Generate SSH Key and add it to the agent
RUN eval "$(ssh-agent -s)" \
    && ssh-keygen \
        -t ed25519 \
        -C "root@dotfiles" \
        -f "${HOME}/.ssh/id_ed25519" \
        -N "" \
    && ssh-add ~/.ssh/id_ed25519

# Install Starship
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# # Install Pyenv
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# Set zsh as default shell and install Oh My Zsh
ENV SHELL=/bin/zsh
RUN chsh -s /bin/zsh \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
