#!/usr/bin/env zsh
# vim: set filetype=zsh
# disable sourcing global dotfiles, located at /etc
# unsetopt globalrcs

# opt out of Azure-Function-Core-Tools Telemetry
# FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1

# export DOCKER_DEFAULT_PLATFORM="linux/amd64"
if [[ -d $ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR ]]; then export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR; fi

# Add more dirs to PATH
if [[ ! "${PATH}" == *:.* ]]; then
    export PATH="${PATH}:."
fi
for dir in bin .bin; do
    if [[ ! "${PATH}" == *${HOME}/${dir}* ]]; then
        export PATH="${HOME}/${dir}:${PATH}"
    fi
done

export FZF_DEFAULT_COMMAND='find -L'
export FZF_DEFAULT_OPTS="--bind 'ctrl-v:execute(vim {})+abort,?:toggle-preview,alt-a:select-all,alt-d:deselect-all' --tiebreak=index --cycle --preview-window right:50%:border:wrap"
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --color=dark,fg:7,bg:-1,hl:5,fg+:15,bg+:8,hl+:13,info:2,prompt:4,pointer:1,marker:3,spinner:4,header:4"
export FZF_CTRL_R_OPTS="--layout=reverse --preview-window hidden"