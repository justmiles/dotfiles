#!/bin/bash

source "$(dirname $0)/../_utility.sh"
exit_if_installed code

set -e

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
