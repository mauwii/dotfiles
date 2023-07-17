# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to 'random', it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=agnoster

# use DEFAULT_USER to disable "user@host" in agnoster-prompt when working locally
DEFAULT_USER="$(id -un)"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled # disable automatic updates
# zstyle ':omz:update' mode auto # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# export DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
export DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
export HIST_STAMPS="dd.mm.yyyy"

# set History file
HISTFILE="${HOME}/.zsh_history"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(
    ssh-agent
    colored-man-pages
)

# Function to add plugin if executable is found
function __add_plugin() {
    if [ $# -gt 2 ]; then
        echo "Usage: __add_plugin <plugin> [<executable>]"
        return 1
    fi
    local _plugin="$1"
    [[ $# -eq 2 ]] && local _executable="$2"
    if command -v "${_executable:-$_plugin}" >/dev/null 2>&1; then
        plugins+=($_plugin)
    fi
}

# plugin array to check
plugins_to_check=(
    argocd
    direnv
    kubectl
    multipass
    poetry
    pyenv
)

# add plugins if executable is found
for plugin in "${plugins_to_check[@]}"; do
    __add_plugin "${plugin}"
done
unset plugins_to_check
__add_plugin azure az

# silent SSH-Agent Start
zstyle ':omz:plugins:ssh-agent' quiet yes
# add Identities from Keychain
zstyle ':omz:plugins:ssh-agent' ssh-add-args --apple-load-keychain

# style for no matches
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# set completion dump file
_comp_dumpfile="${ZDOTDIR:-$HOME}/.zcompdump-$(hostname -s)-${ZSH_VERSION}"
export ZSH_COMPDUMP="${_comp_dumpfile}"

. $ZSH/oh-my-zsh.sh

# User configuration

# Ignore duplicate commands and commands starting with space
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

# Preferred editor for local and remote sessions
if [ -n "$SSH_CONNECTION" ]; then
    export EDITOR='nano'
else
    export EDITOR='code --wait'
    # export GIT_EDITOR="$EDITOR -w"
fi

# Compilation flags
# export ARCHFLAGS='-arch x86_64'

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# use exa as modern ls-replacement
if [ -x "$(which -p exa)" ]; then
    alias ls="$(which exa) --icons --group-directories-first --git"
    LS_EXA=true
fi

alias l="ls -a -h"
alias ll="l -l -g${LS_EXA:+ --accessed --modified --created}"
alias lll="ll -@"
alias lr="ls -R"
alias llr="lr -l"

# add ESP-IDF Directory if it exists
IDF_PATH=~/esp/esp-idf
if [ -f "${IDF_PATH}/export.sh" ]; then
    export ESPIDF="${IDF_PATH}"
    alias getidf=". ${ESPIDF}/export.sh"
else
    unset IDF_PATH
fi

# replace cat with bat, but disable paging to make it behave like cat
if command -v bat >/dev/null 2>&1; then
    alias cat="bat --paging=never"
fi

# dotfiles management
if [ -d "${HOME}/.cfg" ] && command -v git >/dev/null 2>&1; then
    # alias config="git --git-dir=\"${HOME}/.cfg/\" --work-tree=\"$HOME\""
    alias config="git --git-dir=${HOME}/.cfg/ --work-tree=$HOME"
fi

# pipx completion
if command -v pipx >/dev/null 2>&1; then
    eval "$(register-python-argcomplete pipx)"
fi

# iTerm 2 Shell Integration
ITERM2_SHELL_INTEGRATION="${HOME}/.iterm2_shell_integration.zsh"
if [ -s "$ITERM2_SHELL_INTEGRATION" ] && [ "$TERM_PROGRAM" = "iTerm.app" ]; then
    . "$ITERM2_SHELL_INTEGRATION"
fi

if [ -d "${HOMEBREW_PREFIX}" ]; then
    # homebrew zsh-fast-syntax-highlighting
    HB_ZSH_FAST_SYNTAX_HIGHLIGHTING="${HOMEBREW_PREFIX}/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
    if [ -s "${HB_ZSH_FAST_SYNTAX_HIGHLIGHTING}" ]; then
        . "${HB_ZSH_FAST_SYNTAX_HIGHLIGHTING}"
    fi
    # homebrew zsh-autosuggestions plugin
    HB_ZSH_AUTO_SUGGESTIONS="${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    if [ -s "${HB_ZSH_AUTO_SUGGESTIONS}" ]; then
        . "${HB_ZSH_AUTO_SUGGESTIONS}"
    fi
fi
