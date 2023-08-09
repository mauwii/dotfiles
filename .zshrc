# shellcheck shell=bash disable=SC2034

debuglog "loading .zshrc"

# load ~/.profile if not loaded yet
if [ "${DOT_PROFILE:-false}" != "true" ] && [ -r ~/.profile ]; then
    # shellcheck source=.profile
    source ~/.profile
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# unset INFOPATH

# set completion dump file
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump-$(hostname -s)${ZSH_VERSION:+-$ZSH_VERSION}"
export ZSH_COMPDUMP

# set History file
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

# if oh-my-zsh is installed
if [ -d ~/.oh-my-zsh ]; then
    # Path to your oh-my-zsh installation.
    export ZSH=~/.oh-my-zsh

    # Set name of the theme to load --- if set to 'random', it will
    # load a random theme each time oh-my-zsh is loaded, in which case,
    # to know which specific one was loaded, run: echo $RANDOM_THEME
    # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
    ZSH_THEME=agnoster

    # use DEFAULT_USER to disable "user@host" in agnoster-prompt when working locally
    DEFAULT_USER="${USER}"

    # Set list of themes to pick from when loading at random
    # Setting this variable when ZSH_THEME=random will cause zsh to load
    # a theme from this variable instead of looking in $ZSH/themes/
    # If set to an empty array, this variable will have no effect.
    # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

    # Uncomment the following line to use case-sensitive completion.
    CASE_SENSITIVE="true"

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
    # DISABLE_UNTRACKED_FILES_DIRTY="true"

    # Uncomment the following line if you want to change the command execution time
    # stamp shown in the history command output.
    # You can set one of the optional three formats:
    # "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
    # or set a custom format using the strftime function format specifications,
    # see 'man strftime' for details.
    HIST_STAMPS="dd.mm.yyyy"

    # Would you like to use another custom folder than $ZSH/custom?
    # ZSH_CUSTOM=/path/to/new-custom-folder

    # Which plugins would you like to load?
    # Standard plugins can be found in $ZSH/plugins/
    # Custom plugins may be added to $ZSH_CUSTOM/plugins/
    # Example format: plugins=(rails git textmate ruby lighthouse)
    # Add wisely, as too many plugins slow down shell startup.

    plugins=(
        ssh-agent
    )

    # Function to add plugin if executable is found
    function __add_plugin() {
        _plugin="${1}"
        _executable="${2}"
        if [ $# -gt 2 ]; then
            printf "Usage: %s <plugin> [<executable>]" "$0"
            return 1
        fi
        if validate_command "${_executable:-$_plugin}"; then
            plugins+=("${_plugin}")
        fi
    }

    # plugin array to check
    plugins_to_check=(
        argocd
        direnv
        dotnet
        kubectl
        multipass
        poetry
        pyenv
        starship
    )

    # add plugins if executable is found
    for plugin in "${plugins_to_check[@]}"; do
        __add_plugin "${plugin}"
    done
    unset plugins_to_check

    # Add Plugins with different executable
    __add_plugin azure az

    # silent SSH-Agent Start
    zstyle ':omz:plugins:ssh-agent' quiet yes

    # add Identities from Keychain
    if [ "${MACOS}" -eq 1 ]; then
        zstyle ':omz:plugins:ssh-agent' ssh-add-args --apple-load-keychain
    fi

    if [ -r "${ZSH}/oh-my-zsh.sh" ]; then
        debuglog ".zshrc: Loading oh-my-zsh"
        # shellcheck source=.oh-my-zsh/oh-my-zsh.sh disable=SC1094
        source "${ZSH}/oh-my-zsh.sh"
    fi
else
    # try to load starship prompt
    if validate_command starship; then
        debuglog ".zshrc: Loading starship"
        eval "$(starship init zsh)"
    else
        debuglog ".zshrc: Loading default prompt"
        PROMPT='%n@%m %1~ %# '
    fi
fi

# User configuration

# load shared shell configuration if not loaded yet
if [ "${DOT_SHRC:-false}" = "false" ] && [ -r ~/.shrc ]; then
    # shellcheck source=.shrc
    source ~/.shrc
fi

# Ignore duplicate commands and commands starting with space
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

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

# pipx completion
if validate_command pipx; then
    eval "$(register-python-argcomplete pipx)"
fi

# iTerm 2 Shell Integration
ITERM2_SHELL_INTEGRATION=~/.iterm2_shell_integration.zsh
if [ -r "${ITERM2_SHELL_INTEGRATION}" ] \
    && [ "${TERM_PROGRAM:+$TERM_PROGRAM}" = "iTerm.app" ]; then
    # shellcheck source=/dev/null
    source "${ITERM2_SHELL_INTEGRATION}"
else
    unset ITERM2_SHELL_INTEGRATION
fi

if [ -r ~/.zstyles ]; then
    # shellcheck disable=SC1090
    source ~/.zstyles
fi

# These AddOns should be sourced last
if [ -d "${HOMEBREW_PREFIX}" ]; then
    # homebrew zsh-fast-syntax-highlighting plugin
    ZSH_FAST_SYNTAX_HIGHLIGHTING="${HOMEBREW_PREFIX}/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
    if [ -r "${ZSH_FAST_SYNTAX_HIGHLIGHTING}" ]; then
        # shellcheck source=/dev/null
        source "${ZSH_FAST_SYNTAX_HIGHLIGHTING}"
    else
        unset ZSH_FAST_SYNTAX_HIGHLIGHTING
    fi
    # homebrew zsh-autosuggestions plugin
    ZSH_AUTOSUGGEST="${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    if [ -r "${ZSH_AUTOSUGGEST}" ]; then
        # Disable autosuggestion for large buffers.
        export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
        # Enable aynchronous mode.
        export ZSH_AUTOSUGGEST_USE_ASYNC="true"
        # set strategy
        export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        # shellcheck source=/dev/null
        source "${ZSH_AUTOSUGGEST}"
    else
        unset ZSH_AUTOSUGGEST
    fi
fi

DOT_ZSHRC="true"
