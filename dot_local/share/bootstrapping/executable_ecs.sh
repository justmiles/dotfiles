#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed ecs

set -e

VERSION=$(curl -sfL https://api.github.com/repos/justmiles/ecs-cli/releases/latest | jq -r '.tag_name' | sed 's/v//g')
KERNEL=$(uname -s)
MACHINE=$(uname -m)
DOWNLOAD_URL="https://github.com/justmiles/ecs-cli/releases/download/v${VERSION}/ecs_${VERSION}_${KERNEL}_${MACHINE}.tar.gz"

curl -sfLo - $DOWNLOAD_URL | tar -xzf - -C ~/.local/bin ecs
