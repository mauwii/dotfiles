# syntax=docker/dockerfile:1
FROM ubuntu:23.04

LABEL \
    author="mauwii@outlook.de" \
    description="Docker image to debug my dotfiles"

# Enable pipefail
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Enable apt cache
RUN rm -f /etc/apt/apt.conf.d/docker-clean \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' >/etc/apt/apt.conf.d/keep-cache

# Install dependencies
# hadolint ignore=DL3008
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        bash-completion \
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

# Install Pyenv
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# download iTerm2 shell integration
RUN curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh \
    && curl -L https://iterm2.com/shell_integration/bash -o ~/.iterm2_shell_integration.bash

# Set zsh as default shell and install Oh My Zsh
RUN chsh -s /bin/zsh \
    && SHELL="/bin/zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install brew if amd64/x86_64
RUN <<EOT
if [[ "$(uname -m)" = "x86_64" ]]; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
EOT
