#!/usr/bin/env zsh
# vim: set filetype=zsh

# opt out of Azure-Function-Core-Tools Telemetry
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1


# setting some arch dependend Variables
if [[ "${SHELL_ARCH}" == "i386" ]]; then
  # export ARCHFLAGS='-arch x86_64';
  export DOCKER_DEFAULT_PLATFORM="linux/amd64";
elif [[ "${SHELL_ARCH}" == "arm64" ]]; then
  # export ARCHFLAGS='-arch arm64 -arch x86_64';
  export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec";
  export DOCKER_DEFAULT_PLATFORM="linux/arm64";
fi

export ARCHFLAGS='-arch arm64 -arch x86_64';

[[ -d /opt/homebrew/share/zsh-syntax-highlighting/highlighters ]] && export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR='/opt/homebrew/share/zsh-syntax-highlighting/highlighters'

# export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
# export FZF_DEFAULT_OPTS="--bind 'ctrl-v:execute(vim {})+abort,?:toggle-preview,alt-a:select-all,alt-d:deselect-all' --tiebreak=index --cycle --preview-window right:50%:border:wrap"
# export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --color=dark,fg:7,bg:-1,hl:5,fg+:15,bg+:8,hl+:13,info:2,prompt:4,pointer:1,marker:3,spinner:4,header:4"
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info --preview-window right:50%:border:wrap"
export FZF_CTRL_R_OPTS="--layout=reverse --preview-window hidden"

export DOCKER_GATEWAY_HOST='127.0.0.1'