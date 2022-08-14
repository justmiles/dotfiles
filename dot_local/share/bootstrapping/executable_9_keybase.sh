#!/bin/bash

source "$(dirname $0)/_utility.sh"

# limit this to desktop environments
if [ ! "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
  exit 0
fi

exit_if_installed run_keybase

set -e

if [ "$OS" = "manjaro" ]; then
  yes | yay -S keybase-bin
  run_keybase
fi

if [ -e "/keybase/private/$USER/bootstrap.sh" ]; then
  echo "you may want to run this:"
  echo "> /keybase/private/$USER/bootstrap.sh"
fi
