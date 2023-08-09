# shellcheck shell=bash

# add shell functions
if [ -r ~/.functions ]; then
    # shellcheck source=.functions
    . ~/.functions
fi

# don't load global rcs
unset GLOBAL_RCS
