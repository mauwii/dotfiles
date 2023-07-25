# shellcheck shell=sh

# load cross-compatible profile
if [ -r ~/.profile ]; then
    # shellcheck source=.profile
    source ~/.profile
fi
