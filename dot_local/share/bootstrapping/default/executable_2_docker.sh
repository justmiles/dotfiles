#!/bin/bash

source "$(dirname $0)/../_utility.sh"
exit_if_installed docker

set -e

if [ "$OS" = "manjaro" ]; then
    yes | sudo pacman -S docker
fi

sudo systemctl start docker.service
sudo systemctl enable docker.service

sudo usermod -aG docker $USER
