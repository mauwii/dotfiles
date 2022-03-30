# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# warn arch changed
if [[ "${SHELL_ARCH}" != "$(arch)" ]]; then
  echo "Be Careful - yor architecture changed so your env is likely to be messed up!!!"
fi

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
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto # update automatically without asking
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
COMPLETION_WAITING_DOTS="true"

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
  direnv
  colorize
  colored-man-pages
  git
  github
  jsontools
  pip
  python
  ssh-agent
)

# silent SSH-Agent Start
zstyle ':omz:plugins:ssh-agent' quiet yes
# add Identities from Keychain
zstyle ':omz:plugins:ssh-agent' ssh-add-args --apple-load-keychain

source "$ZSH/oh-my-zsh.sh"

# User configuration

# export MANPATH="$(man --path)"

# You may need to manually set your language environment
export LANG="en_US.UTF-8"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='code'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"
ARCHFLAGS="-arch $(uname -m)"
export ARCHFLAGS

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
# alias topgrade="topgrade --disable=pip3"

# dotfiles management
if [[ -d $HOME/.cfg ]]; then
  alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
fi

# alias to start adaptivecards-designer
if [[ -d "${HOME}/Bots/AdaptiveCards/source/nodejs" ]]; then
  alias acarddesigner="(cd ${HOME}/Bots/AdaptiveCards/source/nodejs && npx lerna run start --scope=adaptivecards-designer --stream)"
fi

function rosettaterm() {
  echo "switching to x86_64 architecture"
  if which nvm >/dev/null; then
    nvm deactivate >/dev/null
  fi
  arch -arch x86_64 /bin/zsh -l
}

# only needed wenn $ESPIDF is set
if [[ -d "${ESPIDF}" ]]; then
  alias getidf="source ${IDF_PATH}/export.sh"
fi

# iTerm 2 Shell Integration
if [[ -s "${HOME}/.iterm2_shell_integration.zsh" && ${TERM_PROGRAM} == iTerm.app ]]; then
  source "${HOME}/.iterm2_shell_integration.zsh"
fi

# initialize brewed node version manager
if [[ -d "${HOME}/.nvm.${SHELL_ARCH}" ]]; then
  NVM_DIR="${HOME}/.nvm.${SHELL_ARCH}"
  export NVM_DIR
  # This loads nvm
  if [[ -s "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" ]]; then
    source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"
  fi
  # This loads nvm bash_completion
  if [[ -s "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm" ]]; then
    source "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm"
  fi
  nvm use --lts >/dev/null
fi

# initialize pyenv
if which pyenv >/dev/null; then
  eval "$(pyenv init -)"
  # initialize pyenv-virtualenv
  if which pyenv-virtualenv-init >/dev/null; then
    eval "$(pyenv virtualenv-init -)"
  fi
  # remove pyenv from PATH when executing brew
  if which brew >/dev/null; then
    alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
  fi
fi

# homebrew zsh-autosuggestions plugin
if [[ -s "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Sign git commits with gpg https://gist.github.com/troyfontaine/18c9146295168ee9ca2b30c00bd1b41e
export GPG_TTY=$(tty)

# zsh-syntax-highlighting needs to get sourced at the end because of the way it is hooking the prompt
if [[ -s "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR="$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/highlighters"
  export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR
fi
