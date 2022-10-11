#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed code

set -e

if [ "$OS" = "manjaro" ]; then
    yes | sudo pacman -Su vscode
fi

if [ "$OS" = "fedora" ]; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    dnf check-update
    sudo dnf install code -y
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
