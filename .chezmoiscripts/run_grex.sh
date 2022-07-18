#!/bin/bash

SCRIPT=$(basename $0 | awk -F '.' '{print $2}')
OS=$(cat /etc/os-release | grep "^ID=" | awk -F '=' '{print $2}')

exec > >(trap "" INT TERM; sed "s/^/${SCRIPT}: /")
exec 2> >(trap "" INT TERM; sed "s/^/${SCRIPT}: (stderr) /" >&2)

which grex > /dev/null 2>/dev/null
[ $? -eq 0 ] && [ ! "$FORCE_REINSTALL" = "y" ] && exit 0
echo "installing $SCRIPT"

################################################################
set -e

VERSION=$(curl -sfL https://api.github.com/repos/pemistahl/grex/releases/latest | jq -r '.tag_name' | sed 's/v//g')
DOWNLOAD_URL="https://github.com/pemistahl/grex/releases/download/v${VERSION}/grex-v${VERSION}-x86_64-unknown-linux-musl.tar.gz"

curl -sfLo - $DOWNLOAD_URL | tar -xzf - -C ~/.local/bin grex
