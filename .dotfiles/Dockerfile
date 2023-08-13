# syntax=docker/dockerfile:1
FROM ubuntu:23.04

LABEL \
    author="mauwii@outlook.de" \
    description="Docker image to debug my dotfiles"

# Enable pipefail
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Enable apt cache
RUN rm -f /etc/apt/apt.conf.d/docker-clean \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
    >/etc/apt/apt.conf.d/keep-cache

# Install dependencies
ARG DEBIAN_FRONTEND=noninteractive
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
        exa \
        git \
        jq \
        locales \
        nano \
        neovim \
        npm \
        openssh-client \
        pandoc w3m w3m-img \
        pipx \
        python3-dev python3-pynvim \
        tzdata \
        zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen
ARG TZ=UTC
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    TZ=$TZ

# npm install typescript and neovim globally
# hadolint ignore=DL3016
RUN npm install -g neovim typescript --

# Install Starship
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# create non-root user
ARG DOTFILES_USERNAME=dotfiles
ARG DOTFILES_UID=1000
ARG DOTFILES_GROUP=$DOTFILES_USERNAME
ARG DOTFILES_GID=1000
ENV HOME=/home/$DOTFILES_USERNAME
RUN groupdel --force $DOTFILES_GROUP \
    || groupmod \
        --new-name $DOTFILES_GROUP \
        --gid "$DOTFILES_GID" \
        "$(getent group "$DOTFILES_GID" | grep ":$DOTFILES_GID:" | cut -d: -f1)" \
    && groupadd \
        --force \
        --system \
        --gid=$DOTFILES_GID \
        $DOTFILES_GROUP \
    && useradd \
        --create-home \
        --home=$HOME \
        --system \
        --groups=$DOTFILES_GROUP \
        --uid=$DOTFILES_UID \
        --gid=$DOTFILES_GID \
        $DOTFILES_USERNAME
USER $DOTFILES_USERNAME
WORKDIR $HOME

# Generate SSH Key and add it to the agent
RUN eval "$(ssh-agent -s)" \
    && ssh-keygen \
        -t ed25519 \
        -C "$DOTFILES_USERNAME@dotfiles" \
        -f "${HOME}/.ssh/id_ed25519" \
        -N "" \
    && ssh-add ~/.ssh/id_ed25519

# # Install Pyenv
# ARG PYTHON_VERSION=3.10.12
# # hadolint ignore=DL3013
# RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
#     && export PYENV_ROOT"=${HOME}/.pyenv" \
#     && export PATH="${PYENV_ROOT}/bin:${PATH}" \
#     && eval "$(pyenv init --path)" \
#     && pyenv install $PYTHON_VERSION \
#     && pyenv global $PYTHON_VERSION \
#     && pyenv rehash

ENV PYTHON3_HOST_PROG /usr/bin/python3

# install SpaceVim
RUN mkdir -p $HOME/.config $HOME/.SpaceVim.d \
    && curl https://raw.githubusercontent.com/SpaceVim/SpaceVim/master/docker/init.toml >$HOME/.SpaceVim.d/init.toml \
    && curl -sLf https://spacevim.org/install.sh | bash \
    && nvim --headless +'call dein#install#_update([], "install", v:false)' +qall \
    && rm $HOME/.SpaceVim.d/init.toml

# install Oh My Zsh
RUN SHELL="/bin/zsh" \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# expose SSH
EXPOSE 22

# # download iTerm2 shell integration
# RUN curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh \
#     && curl -L https://iterm2.com/shell_integration/bash -o ~/.iterm2_shell_integration.bash

# # install brew if amd64/x86_64
# RUN <<EOT
# if [[ "$(uname -m)" = "x86_64" ]]; then
#     NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# fi
# EOT
