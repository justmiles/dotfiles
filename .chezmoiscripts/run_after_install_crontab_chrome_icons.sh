#!/bin/bash
# from: https://gist.github.com/ninogresenz/868d806723fe0ece9ad70f395f19619e

set -e

OS=$(cat /etc/os-release | grep "^ID=" | awk -F '=' '{print $2}')

# limit this to manjaro
if [ ! "$OS" = "manjaro" ]; then
  exit 0
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
  echo "  changing file"
  sed -E -i 's!^(Exec=)(.*)$!\1\2'"${CMD}"'!g' $file
done

update-desktop-database $DIR
