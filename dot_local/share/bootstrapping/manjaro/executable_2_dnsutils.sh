#!/bin/bash

source "$(dirname $0)/../_utility.sh"
exit_if_installed nslookup

set -e

if [ "$OS" = "manjaro" ]; then
  yes y | sudo pacman -S dnsutils
fi
