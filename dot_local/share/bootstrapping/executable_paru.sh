#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed paru

set -e

# Only install this on Manjaro
if [ ! "$OS" = "manjaro" ]; then
  exit 0
fi

sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
yes y | makepkg -si
