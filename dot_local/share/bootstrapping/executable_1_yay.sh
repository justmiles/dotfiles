#!/bin/bash

source "$(dirname $0)/_utility.sh"

# limit this to manjaro
if [ ! "$OS" = "manjaro" ]; then
  exit 0
fi

exit_if_installed yay

set -e

source /etc/profile.d/go.sh
yes | sudo pacman -S git make
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
yes | makepkg -si
