#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed csvq

set -e

VERSION=$(curl -sfL https://api.github.com/repos/mithrandie/csvq/releases/latest | jq -r '.tag_name' | sed 's/v//g')
KERNEL=$(uname -s)
MACHINE=$(uname -m)
DOWNLOAD_URL="https://github.com/mithrandie/csvq/releases/download/v${VERSION}/csvq-v${VERSION}-linux-amd64.tar.gz"

curl -sfLo - $DOWNLOAD_URL | tar -xzf - -C ~/.local/bin --strip-components=1 csvq-v${VERSION}-linux-amd64/csvq
