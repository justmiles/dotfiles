#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed docker

set -e

if [ "$OS" = "manjaro" ]; then
    yes | sudo pacman -S docker
fi

if [ "$OS" = "mint" ]; then

    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg


    echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$UBUNTU_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update -o Dir::Etc::sourcelist=/etc/apt/sources.list.d/docker.list 

    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

fi

sudo systemctl start docker.service
sudo systemctl enable docker.service

sudo usermod -aG docker $USER
