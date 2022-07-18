#!/bin/bash

SCRIPT=$(basename $0 | awk -F '.' '{print $2}')
OS=$(cat /etc/os-release | grep "^ID=" | awk -F '=' '{print $2}')

exec > >(trap "" INT TERM; sed "s/^/${SCRIPT}: /")
exec 2> >(trap "" INT TERM; sed "s/^/${SCRIPT}: (stderr) /" >&2)

which go > /dev/null 2>/dev/null
[ $? -eq 0 ] && [ ! "$FORCE_REINSTALL" = "y" ] && exit 0
echo "installing $SCRIPT"

################################################################
set -e

curl -sLo - https://go.dev/dl/go1.18.3.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
echo 'export PATH=$PATH:/usr/local/go/bin:/root/go/bin:$HOME/go/bin' > sudo tee /etc/profile.d/go.sh
