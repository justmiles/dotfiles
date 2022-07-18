#!/bin/bash

SCRIPT=$(basename $0 | awk -F '.' '{print $2}')
OS=$(cat /etc/os-release | grep "^ID=" | awk -F '=' '{print $2}')

exec > >(trap "" INT TERM; sed "s/^/${SCRIPT}: /")
exec 2> >(trap "" INT TERM; sed "s/^/${SCRIPT}: (stderr) /" >&2)

which git-bump > /dev/null 2>/dev/null
[ $? -eq 0 ] && [ ! "$FORCE_REINSTALL" = "y" ] && exit 0
echo "installing $SCRIPT"

################################################################
set -e

curl -sf https://gobinaries.com/b4b4r07/git-bump | PREFIX=~/.local/bin sh
