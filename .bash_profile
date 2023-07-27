#!/usr/bin/env bash

# load cross-compatible profile
if [ -r ~/.profile ]; then
    # shellcheck source=.profile
    . ~/.profile
fi

# load rc if interactive
if [ "${BASH-no}" != "no" ] && [ -r ~/.bashrc ]; then
    # shellcheck source=.bashrc
    . ~/.bashrc
fi
