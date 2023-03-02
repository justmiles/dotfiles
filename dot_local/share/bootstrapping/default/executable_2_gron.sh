#!/bin/bash

source "$(dirname $0)/../_utility.sh"
exit_if_installed gron

set -e

VERSION=$(curl -sfL https://api.github.com/repos/tomnomnom/gron/releases/latest | jq -r '.tag_name' | sed 's/v//g')
DOWNLOAD_URL="https://github.com/tomnomnom/gron/releases/download/v${VERSION}/gron-linux-amd64-${VERSION}.tgz"

curl -sfLo - $DOWNLOAD_URL | tar -xzf - -C ~/.local/bin
