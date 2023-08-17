# syntax=docker/dockerfile:1
FROM ubuntu:23.04

LABEL org.opencontainers.image.author="mauwii@outlook.de"
LABEL org.opencontainers.image.description="Docker image to debug my dotfiles"

# Enable non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Enable pipefail
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Enable apt cache
RUN rm -f /etc/apt/apt.conf.d/docker-clean \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
    >/etc/apt/apt.conf.d/keep-cache

# Install dependencies
# hadolint ignore=DL3008
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        bash-completion \
        bat \
        build-essential \
        ca-certificates \
        curl \
        direnv \
        fd-find \
        exa \
        fzf \
        git \
        jq \
        locales \
        lua5.3 \
        neovim \
        openssh-server \
        python3-dev \
        python3-neovim \
        silversearcher-ag \
        tzdata \
        universal-ctags \
        zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the locale
RUN localedef \
    -i en_US \
    -c \
    -f UTF-8 \
    -A /usr/share/locale/locale.alias en_US.UTF-8

# enable public key authentication and verbose logging
RUN echo "mkdir -p /var/run/sshd" >>/etc/rc.local \
    && printf "PubkeyAuthentication yes\n" >/etc/ssh/sshd_config.d/pubkeyauth.conf \
    && printf "loglevel VERBOSE\n" >/etc/ssh/sshd_config.d/loglevel.conf

# expose SSH default port
EXPOSE 22

# Install Pyenv
ENV PYENV_ROOT="/root/.pyenv"
RUN git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT \
    # Install pyenv-virtualenv
    && git clone https://github.com/pyenv/pyenv-virtualenv.git $PYENV_ROOT/plugins/pyenv-virtualenv

# Install Starship
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# install SpaceVim
ENV PYTHON3_HOST_PROG /usr/bin/python3
# hadolint ignore=DL3003
RUN mkdir -p "$HOME/.config" "$HOME/.SpaceVim.d" \
    # get config with all plugins enabled
    && curl https://raw.githubusercontent.com/SpaceVim/SpaceVim/master/docker/init.toml \
        >"$HOME/.SpaceVim.d/init.toml" \
    # install SpaceVim
    && curl -sLf https://spacevim.org/install.sh | bash -s -- --install neovim \
    # checkout v2.2.0 instead of staying on dev
    && git -C "$HOME/.SpaceVim" checkout v2.2.0 \
    # install plugins
    && nvim --headless +"call dein#install#_update([],'install',v:false)" +qall \
    # remove config
    && rm -rf "$HOME/.SpaceVim.d/init.toml"

# install Oh My Zsh
RUN SHELL="/bin/zsh" \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# download iTerm2 shell integration
RUN curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh \
    && curl -L https://iterm2.com/shell_integration/bash -o ~/.iterm2_shell_integration.bash

# Disable non-interactive mode
ENV DEBIAN_FRONTEND=dialog

# # install brew if amd64/x86_64
# RUN <<EOT
# if [[ "$(uname -m)" = "x86_64" ]]; then
#     NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# fi
# EOT
