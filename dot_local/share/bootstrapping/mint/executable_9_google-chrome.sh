#!/bin/bash

source "$(dirname $0)/../_utility.sh"

# limit this to desktop environments
if [ ! "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
  exit 0
fi

exit_if_installed google-chrome-stable

set -e

if [ "$OS" = "manjaro" ]; then
  yes | yay -S google-chrome
fi

DIR="$HOME/.local/share/applications"
PATTERN="chrome-*.desktop"

if ! command -v xdotool > /dev/null; then
  echo "installing xdotool..."
  yes | sudo pacman -S xdotool
fi

for file in $(ls $DIR/$PATTERN); do
  ID=$(grep -m 1 Exec $file | sed -E 's/^(.*)--app-id=(\w*).*$/\2/g')
  CMD=" \&\& xdotool search --sync --classname $ID set_window --class $ID"
  if grep -q "$CMD" $file >/dev/null 2>&1; then
    continue
  fi
  sed -E -i 's!^(Exec=)(.*)$!\1\2'"${CMD}"'!g' $file
done

update-desktop-database $DIR
gopass