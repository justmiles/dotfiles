#!/bin/bash

source "$(dirname $0)/../_utility.sh"
exit_if_installed ecs-deploy

set -e

VERSION=$(curl -sfL https://api.github.com/repos/justmiles/ecs-deploy/releases/latest | jq -r '.tag_name' | sed 's/v//g')
KERNEL=$(uname -s)
MACHINE=$(uname -m)
DOWNLOAD_URL="https://github.com/justmiles/ecs-deploy/releases/download/v${VERSION}/ecs-deploy_${VERSION}_${KERNEL}_${MACHINE}.tar.gz"

curl -sfLo - $DOWNLOAD_URL | tar -xzf - -C ~/.local/bin
