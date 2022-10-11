#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed docker

set -e

if [ "$OS" = "manjaro" ]; then
    yes | sudo pacman -S docker
fi

if [ "$OS" = "fedora" ]; then
    sudo yum install -y docker
fi

sudo systemctl enable --now docker

sudo usermod -aG docker $USER
