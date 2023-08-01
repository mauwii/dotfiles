# shellcheck shell=bash

# add shell functions
if [ -r ~/.functions ]; then
    # shellcheck source=.functions
    . ~/.functions
fi

# add aliases
if [ -r ~/.aliases ]; then
    # shellcheck source=.aliases
    . ~/.aliases
fi
