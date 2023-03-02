#!/bin/bash

source "$(dirname $0)/../_utility.sh"
exit_if_installed ssm-parameter-store

set -e

VERSION=$(curl -sfL https://api.github.com/repos/justmiles/ssm-parameter-store/releases/latest | jq -r '.tag_name' | sed 's/v//g')
KERNEL=$(uname -s)
MACHINE=$(uname -m)
DOWNLOAD_URL="https://github.com/justmiles/ssm-parameter-store/releases/download/v${VERSION}/ssm-parameter-store_${VERSION}_${KERNEL}_${MACHINE}.tar.gz"

curl -sfLo - $DOWNLOAD_URL | tar -xzf - -C ~/.local/bin
