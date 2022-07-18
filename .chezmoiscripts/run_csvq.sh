#!/bin/bash

SCRIPT=$(basename $0 | awk -F '.' '{print $2}')
OS=$(cat /etc/os-release | grep "^ID=" | awk -F '=' '{print $2}')

exec > >(trap "" INT TERM; sed "s/^/${SCRIPT}: /")
exec 2> >(trap "" INT TERM; sed "s/^/${SCRIPT}: (stderr) /" >&2)

which csvq > /dev/null 2>/dev/null
[ $? -eq 0 ] && [ ! "$FORCE_REINSTALL" = "y" ] && exit 0
echo "installing $SCRIPT"

################################################################
set -e

VERSION=$(curl -sfL https://api.github.com/repos/mithrandie/csvq/releases/latest | jq -r '.tag_name' | sed 's/v//g')
KERNEL=$(uname -s)
MACHINE=$(uname -m)
DOWNLOAD_URL="https://github.com/mithrandie/csvq/releases/download/v${VERSION}/csvq-v${VERSION}-linux-amd64.tar.gz"

curl -sfLo - $DOWNLOAD_URL | tar -xzf - -C ~/.local/bin --strip-components=1 csvq-v${VERSION}-linux-amd64/csvq
