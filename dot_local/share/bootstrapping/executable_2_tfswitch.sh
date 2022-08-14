#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed tfswitch

curl -sfLo - https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash /dev/stdin -b ~/.local/bin