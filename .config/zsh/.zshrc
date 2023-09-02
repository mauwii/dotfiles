# shellcheck disable=SC2034,1091

# add shell functions
if ! debuglog >/dev/null 2>&1 && [[ -r ~/.functions ]]; then
    # shellcheck source=.functions
    . ~/.functions
fi

if [[ "${DOT_ZSHRC}" = "true" ]]; then
    debuglog "already loaded .zshrc"
    return
else
    debuglog "begin loading .zshrc"
fi

# load ~/.profile if not loaded yet
if [[ -r ~/.profile ]]; then
    # shellcheck source=.profile
    source ~/.profile
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# unset INFOPATH

# set completion dump file
ZSH_COMPDUMP="${ZDOTDIR:-${HOME:-.cache}}/.zcompdump-$(hostname -s)${ZSH_VERSION:+-${ZSH_VERSION}}"
export ZSH_COMPDUMP

# set History file
HISTFILE=${ZDOTDIR:-${HOME}}/.zsh_history

# if oh-my-zsh is installed
if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    # Path to your oh-my-zsh installation.
    export ZSH="${HOME}/.oh-my-zsh"

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
        iTerm2
    )

    # Function to add plugin if executable is found
    function __add_plugin() {
        _plugin="${1}"
        _executable="${2}"
        if [[ $# -gt 2 ]]; then
            printf "Usage: %s <plugin> [<executable>]" "$0"
            return 1
        fi
        if validate_command "${_executable:-${_plugin}}"; then
            plugins+=("${_plugin}")
        fi
    }

    # plugin array to check
    plugins_to_check=(
        argocd
        direnv
        dotnet
        fzf
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
    __add_plugin gitfast git

    # silent SSH-Agent Start
    zstyle ':omz:plugins:ssh-agent' quiet yes

    # add Identities from Keychain
    if [[ "${MACOS}" = "1" ]]; then
        zstyle ':omz:plugins:ssh-agent' ssh-add-args --apple-load-keychain
    fi

    # source iTerm2 shell integration
    zstyle :omz:plugins:iterm2 shell-integration yes

    if [[ -r "${ZSH}/oh-my-zsh.sh" ]]; then
        # shellcheck source=.oh-my-zsh/oh-my-zsh.sh disable=SC1094
        debuglog "Loading oh-my-zsh"
        source "${ZSH}/oh-my-zsh.sh"
    fi
else
    # try to load starship prompt
    if validate_command starship; then
        debuglog ".zshrc: Loading starship"
        eval "$(starship init zsh || true)"
    else
        debuglog ".zshrc: Loading default prompt"
        PROMPT='%n@%m %1~ %# '
    fi
fi

# User configuration

# load shared shell configuration
if [[ -r ~/.shrc ]]; then
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
if validate_command pipx && validate_command register-python-argcomplete; then
    eval "$(register-python-argcomplete pipx || true)"
fi

# ensure docker completion
if validate_command docker && validate_command brew; then
    etc=/Applications/Docker.app/Contents/Resources/etc
    if [[ -d $etc && -d "$(brew --prefix)/share/zsh/site-functions" ]]; then
        ln -sf $etc/docker.zsh-completion "$(brew --prefix)/share/zsh/site-functions/_docker"
        if validate_command docker-compose; then
            ln -sf $etc/docker-compose.zsh-completion "$(brew --prefix)/share/zsh/site-functions/_docker-compose"
        fi
    fi
fi

# act set docker host
if validate_command act; then
    act() {
        local parameters=()
        [[ -f ./.act/.secrets ]] && parameters+=(--secret-file ./.act/.secrets)
        [[ -f ./.act/.env ]] && parameters+=(--env-file ./.act/.env)
        env DOCKER_HOST="$(docker context inspect -f '{{.Endpoints.docker.Host}}')" \
            "$(which -p act)" \
            -s GITHUB_TOKEN="$(gh auth token)" \
            --actor "${USER}" \
            "${parameters[@]}" \
            "$@"
    }
fi

# enable hidden files in completions
# _comp_options+=(globdots)

# load zstyles
if [[ -r "${ZDOTDIR:-$HOME}/.zstyles" ]]; then
    # shellcheck disable=SC1090
    source "${ZDOTDIR:-$HOME}/.zstyles"
fi

# load fzf if installed
if validate_command fzf; then
    if [[ -f ~/.fzf ]]; then
        # shellcheck source=.fzf
        source ~/.fzf >/dev/null 2>&1
    fi
    if [[ -f ~/.fzf.zsh ]]; then
        # shellcheck source=.fzf.zsh
        source ~/.fzf.zsh >/dev/null 2>&1
    fi
fi

# These AddOns should be sourced last
# shellcheck disable=SC2154
if validate_command brew; then
    # homebrew zsh-fast-syntax-highlighting plugin
    ZSH_FAST_SYNTAX_HIGHLIGHTING="$(brew --prefix)/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
    if [[ -r "${ZSH_FAST_SYNTAX_HIGHLIGHTING}" ]]; then
        # shellcheck source=/dev/null
        source "${ZSH_FAST_SYNTAX_HIGHLIGHTING}"
        debuglog "loaded zsh-fast-syntax-highlighting"
    else
        unset ZSH_FAST_SYNTAX_HIGHLIGHTING
    fi
    # homebrew zsh-autosuggestions plugin
    ZSH_AUTOSUGGEST="$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    if [[ -r "${ZSH_AUTOSUGGEST}" ]]; then
        # shellcheck source=/dev/null
        source "${ZSH_AUTOSUGGEST}"
        debuglog "loaded zsh-autosuggestions"
        # # Disable autosuggestion for large buffers.
        export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
        # # Enable aynchronous mode.
        export ZSH_AUTOSUGGEST_USE_ASYNC="true"
        # set strategy
        export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    else
        unset ZSH_AUTOSUGGEST
    fi
fi

# # iTerm 2 Shell Integration
ITERM2_SHELL_INTEGRATION="${HOME}/iterm2_shell_integration.zsh"

# shellcheck disable=SC2154
if [[ -r "${ITERM2_SHELL_INTEGRATION}" ]] \
    && [[ "${LC_TERMINAL}" = "iTerm2" ]]; then
    # shellcheck source=.iterm2_shell_integration.zsh
    source "${ITERM2_SHELL_INTEGRATION}"
else
    unset ITERM2_SHELL_INTEGRATION
fi

DOT_ZSHRC="true"

debuglog "done loading .zshrc"
