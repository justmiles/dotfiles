#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed drone

set -e

curl -sfLo - https://github.com/harness/drone-cli/releases/latest/download/drone_linux_amd64.tar.gz | tar -xzf - -C ~/.local/bin