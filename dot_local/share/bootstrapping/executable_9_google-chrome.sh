#!/bin/bash

source "$(dirname $0)/_utility.sh"

# limit this to desktop environments
exit_if_not_desktop

exit_if_installed google-chrome-stable

set -e

if [ "$OS" = "manjaro" ]; then
  yes | yay -S google-chrome
fi

if [ "$OS" = "fedora" ]; then
    sudo yum install -y google-chrome
fi