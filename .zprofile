# Begin with a clear Path and set SHELL_ARCH env
eval "$(env -u PATH /usr/libexec/path_helper -s)"

export LC_CTYPE=en_US.UTF-8
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.caches"

# add brew to env
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
