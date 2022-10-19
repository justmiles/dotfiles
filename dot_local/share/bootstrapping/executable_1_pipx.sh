#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed pipx

set -e

python3 -m pip install --user pipx
