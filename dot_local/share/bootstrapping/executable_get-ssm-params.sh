#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed get-ssm-params

set -e

VERSION=$(curl -sfL https://api.github.com/repos/justmiles/go-get-ssm-params/releases/latest | jq -r '.tag_name' | sed 's/v//g')
KERNEL=$(uname -s)
MACHINE=$(uname -m)
DOWNLOAD_URL="https://github.com/justmiles/go-get-ssm-params/releases/download/v${VERSION}/get-ssm-params_${VERSION}_${KERNEL}_${MACHINE}.tar.gz"

curl -sfLo - $DOWNLOAD_URL | tar -xzf - -C ~/.local/bin
