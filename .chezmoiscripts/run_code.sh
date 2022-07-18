#!/bin/bash

SCRIPT=$(basename $0 | awk -F '.' '{print $2}')
OS=$(cat /etc/os-release | grep "^ID=" | awk -F '=' '{print $2}')

exec > >(trap "" INT TERM; sed "s/^/${SCRIPT}: /")
exec 2> >(trap "" INT TERM; sed "s/^/${SCRIPT}: (stderr) /" >&2)

which code > /dev/null 2>/dev/null
[ $? -eq 0 ] && [ ! "$FORCE_REINSTALL" = "y" ] && exit 0
echo "installing $SCRIPT"

################################################################
set -e

if [ "$OS" = "manjaro" ]; then
    yes | sudo pacman -Su vscode
fi

# Install extensions
for item in \
      golang.go \
      hashicorp.terraform \
      ms-python.python \
      redhat.java \
      gabrielbb.vscode-lombok \
      esbenp.prettier-vscode \
      redhat.vscode-yaml \
      jkillian.custom-local-formatters \
      eamodio.gitlens \
      jebbs.plantuml \
      pkief.material-icon-theme \
      zhuangtongfa.Material-theme \
      tabnine.tabnine-vscode
do code --force --install-extension $item; done
