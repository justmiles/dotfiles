#!/bin/bash

source "$(dirname $0)/../_utility.sh"
exit_if_installed tilix

yes | sudo pacman -Su tilix
