#!/bin/bash

source "$(dirname $0)/../_utility.sh"
exit_if_installed task

set -e

if [ "$OS" = "manjaro" ]; then
  yes | sudo pacman -Su task
fi
