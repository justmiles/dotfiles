#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed pip

dnf check-update -y
sudo dnf -y install python3-pip
