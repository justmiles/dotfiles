#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed nomad

set -e

curl -sfLo - https://releases.hashicorp.com/nomad/1.2.3/nomad_1.2.3_linux_amd64.zip | busybox unzip -qd ~/.local/bin -
chmod +x ~/.local/bin/nomad
