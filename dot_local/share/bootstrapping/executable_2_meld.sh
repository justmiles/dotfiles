#!/bin/bash

source "$(dirname $0)/_utility.sh"

# limit this to desktop environments
exit_if_not_desktop

exit_if_installed meld

set -e

if [ "$OS" = "manjaro" ]; then
  yes y | sudo pacman -S meld
fi


if [ "$OS" = "fedora" ]; then
  sudo yum install -y meld
fi
