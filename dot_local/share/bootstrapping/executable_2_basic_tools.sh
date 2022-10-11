#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed vim

if [ "$OS" = "manjaro" ]; then
    yes | sudo pacman -Su mlocate xclip bash-completion vim unzip jq net-tools
    sudo rm -rf /usr/bin/vi
    sudo ln -s /usr/bin/vim /usr/bin/vi
fi

if [ "$OS" = "fedora" ]; then
  sudo yum install -y xclip bash-completion vim unzip jq net-tools
fi
