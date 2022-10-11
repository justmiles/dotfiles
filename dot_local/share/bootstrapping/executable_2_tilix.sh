#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed tilix

set -e

if [ "$OS" = "manjaro" ]; then
    yes | sudo pacman -Su tilix
fi

if [ "$OS" = "fedora" ]; then
    sudo yum install -y tilix
fi