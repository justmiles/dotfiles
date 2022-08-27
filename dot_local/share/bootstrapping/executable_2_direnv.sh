#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed direnv

if [ "$OS" = "manjaro" ]; then
    yes | sudo pacman -Su direnv
fi
