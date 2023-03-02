#!/bin/bash

source "$(dirname $0)/../_utility.sh"
exit_if_installed jc

set -e

VERSION=$(curl -sfL https://api.github.com/repos/justmiles/jumpcloud-cli/releases/latest | jq -r '.tag_name' | sed 's/v//g')
KERNEL=$(uname -s)
MACHINE=$(uname -m)
DOWNLOAD_URL="https://github.com/justmiles/jumpcloud-cli/releases/download/v${VERSION}/jumpcloud-cli_${VERSION}_${KERNEL}_${MACHINE}.tar.gz"

curl -sfLo - $DOWNLOAD_URL | tar -xzf - -C ~/.local/bin jc
