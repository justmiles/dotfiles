#!/bin/bash

source "$(dirname $0)/../_utility.sh"
exit_if_installed busybox

set -e

if [ "$OS" = "manjaro" ]; then
  yes | sudo pacman -S busybox
fi
