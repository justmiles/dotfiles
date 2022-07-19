#!/bin/bash

SCRIPT=$(basename $0 | awk -F '.' '{print $2}')
OS=$(cat /etc/os-release | grep "^ID=" | awk -F '=' '{print $2}')

exec > >(trap "" INT TERM; sed "s/^/${SCRIPT}: /")
exec 2> >(trap "" INT TERM; sed "s/^/${SCRIPT}: (stderr) /" >&2)


[ ! "$FORCE_REINSTALL" = "y" ] && exit 0
echo "installing $SCRIPT"

################################################################
set -e

if [ "$OS" = "manjaro" ]; then
    yes | sudo pacman -Su mlocate xclip bash-completion vim unzip jq net-tools
    sudo rm -rf /usr/bin/vi
    sudo ln -s /usr/bin/vim /usr/bin/vi
fi
