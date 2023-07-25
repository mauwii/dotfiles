#!/usr/bin/env bash

# load cross-compatible profile
# shellcheck source=.profile
if [ -r ~/.profile ]; then
    . ~/.profile
fi

# load rc if interactive
if [ "${BASH-no}" != "no" ] && [ -r ~/.bashrc ]; then
    . ~/.bashrc
fi
