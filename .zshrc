# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to 'random', it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME='agnoster'

# use DEFAULT_USER to disable "user@host" in agnoster-prompt when working locally
DEFAULT_USER="$(whoami)"

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
# DISABLE_MAGIC_FUNCTIONS="true"

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
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(
  colorize
  colored-man-pages
  direnv
  fzf
  gpg-agent
  jsontools
  pip
  python
  ssh-agent
)

export FZF_BASE="$(brew --prefix fzf)"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS='--preview "bat --color=always --style=numbers --line-range=:500 {}"'
if [[ -f "${HOME}/.fzf.zsh" ]]; then
  source "${HOME}/.fzf.zsh"
fi

# silent SSH-Agent Start
zstyle ':omz:plugins:ssh-agent' quiet yes
# add Identities from Keychain
zstyle ':omz:plugins:ssh-agent' ssh-add-args --apple-load-keychain
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# Only display targets tag for make command completion
zstyle ':completion:*:*:make::' tag-order 'targets variables'
# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u ${USER} -o pid,user,comm -w -w"

if type brew &>/dev/null; then
  fpath+="${HOMEBREW_PREFIX}/share/zsh/site-functions"
  fpath+="${HOMEBREW_PREFIX}/share/zsh-completions"
fi

source "${ZSH}/oh-my-zsh.sh"

# User configuration

export MANPATH="$(man --path)"

# You may need to manually set your language environment
# export LANG="en_US.UTF-8"

# Preferred editor for local and remote sessions
if [[ -n "${SSH_CONNECTION}" ]]; then
  export EDITOR='nano'
else
  export EDITOR='code'
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

alias l='ls -GAhH'
alias ll='ls -GAhHlO'
alias lll='ls -GAhHlO@'
alias lr='ls -R'

# add ESP-IDF Directory if it exists
if [[ -d "${HOME}/esp/esp-idf" ]]; then
  export IDF_PATH="${HOME}/esp/esp-idf"
  export ESPIDF="${IDF_PATH}"
  alias getidf='source "${ESPIDF}/export.sh"'
fi

# replace cat with bat, but disable paging to make it behave like cat
if type bat &>/dev/null; then
  alias cat='bat --paging never'
fi

# dotfiles management
if [[ -d "${HOME}/.cfg" ]]; then
  alias config='git --git-dir="${HOME}/.cfg/" --work-tree="${HOME}"'
fi

# alias to start adaptivecards-designer
if [[ -d "${HOME}/Bots/AdaptiveCards/source/nodejs" ]]; then
  alias acarddesigner="(cd ${HOME}/Bots/AdaptiveCards/source/nodejs && npx lerna run start --scope=adaptivecards-designer --stream)"
fi

# function to switch current Terminal Environment to rosetta emulated x86_64
function rosettaterm() {
  if [[ "$(uname -m)" == "x86_64" ]]; then
    echo "Already using x86_64 architecture"
  else
    echo "switching to x86_64 architecture"
    env -u PATH -u MANPATH -u INFOPATH \
      arch -arch x86_64 /bin/zsh -l
  fi
  exit
}

# Homebrew Command-not-found
if [[ -r "${HOMEBREW_PREFIX}/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh" ]]; then
  HB_CNF_HANDLER="${HOMEBREW_PREFIX}/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
  source "$HB_CNF_HANDLER"
fi

# set History file
export HISTFILE="${HOME}/.zsh_history"

# iTerm 2 Shell Integration
if [[ -s "${HOME}/.iterm2_shell_integration.zsh" && "${TERM_PROGRAM}" = "iTerm.app" ]]; then
  source "${HOME}/.iterm2_shell_integration.zsh"
fi

# Initialize pyenv
if [[ -d "${HOME}/.pyenv" || -n "${PYENV_ROOT}" ]]; then
  [[ -z "${PYENV_ROOT}" && -d "${HOME}/.pyenv" ]] && export PYENV_ROOT="${HOME}/.pyenv"
  command -v pyenv &>/dev/null || path+="${PYENV_ROOT}/bin"
  eval "$(pyenv init -)"
  # initialize pyenv-virtualenv
  [[ -d "${PYENV_ROOT}/plugins/pyenv-virtualenv" ]] && eval "$(pyenv virtualenv-init -)"
  # fix brew doctor's warning
  if type brew &>/dev/null; then
    alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
  fi
fi

if type brew &>/dev/null; then
  # homebrew zsh-autosuggestions plugin
  if [[ -s "$(brew --prefix zsh-autosuggestions)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$(brew --prefix zsh-autosuggestions)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  fi

  # zsh fast syntax highlighting
  if [[ -r "$(brew --prefix zsh-fast-syntax-highlighting)/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]]; then
    source "$(brew --prefix zsh-fast-syntax-highlighting)/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
  fi
fi
