#!/bin/bash

source "$(dirname $0)/../_utility.sh"
exit_if_installed grex

set -e

VERSION=$(curl -sfL https://api.github.com/repos/pemistahl/grex/releases/latest | jq -r '.tag_name' | sed 's/v//g')
DOWNLOAD_URL="https://github.com/pemistahl/grex/releases/download/v${VERSION}/grex-v${VERSION}-x86_64-unknown-linux-musl.tar.gz"

curl -sfLo - $DOWNLOAD_URL | tar -xzf - -C ~/.local/bin grex
