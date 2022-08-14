#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed whois

set -e


VERSION=$(curl -sfL https://api.github.com/repos/likexian/whois/releases/latest | jq -r '.tag_name' | sed 's/v//g')
DOWNLOAD_URL="https://github.com/likexian/whois/releases/download/v${VERSION}/whois-linux-amd64.tar.gz"

curl -sfLo - $DOWNLOAD_URL | tar -xzf - -C ~/.local/bin --strip-components=1 whois/whois
