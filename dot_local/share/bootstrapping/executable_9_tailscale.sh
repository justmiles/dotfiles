#!/bin/bash

source "$(dirname $0)/_utility.sh"

# limit this to desktop environments
if [ ! "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
  exit 0
fi

exit_if_installed tailscale

set -e

if [ "$OS" = "manjaro" ]; then
  yes | sudo pacman -S tailscale
  sudo systemctl enable --now tailscaled
fi
