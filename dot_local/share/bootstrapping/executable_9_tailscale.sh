#!/bin/bash

source "$(dirname $0)/_utility.sh"

# limit this to desktop environments
exit_if_not_desktop

exit_if_installed tailscale

set -e

if [ "$OS" = "manjaro" ]; then
  yes | sudo pacman -S tailscale
  sudo systemctl enable --now tailscaled
fi

if [ "$OS" = "fedora" ]; then
  sudo dnf config-manager --add-repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
  sudo dnf install tailscale -y
  sudo systemctl enable --now tailscaled
fi
