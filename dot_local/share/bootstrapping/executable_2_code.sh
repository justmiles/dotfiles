#!/usr/bin/env bash

source "$(dirname $0)/_utility.sh"
exit_if_installed code

set -e

if [ "$(cat /etc/os-release | grep "^NAME" | awk -F '=' '{print $2}' | sed 's/"//g')" = "Linux Mint" ]; then
    sudo apt install software-properties-common apt-transport-https wget -y
    sudo wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt-get update
    sudo apt-get install -y code
fi

if [ "$OS" = "manjaro" ]; then
    yes | sudo pacman -Su vscode
fi

# Install extensions
for item in \
      golang.go \
      hashicorp.terraform \
      ms-python.python \
      redhat.java \
      gabrielbb.vscode-lombok \
      esbenp.prettier-vscode \
      redhat.vscode-yaml \
      jkillian.custom-local-formatters \
      eamodio.gitlens \
      jebbs.plantuml \
      pkief.material-icon-theme \
      zhuangtongfa.Material-theme \
      tabnine.tabnine-vscode
do code --force --install-extension $item; done
