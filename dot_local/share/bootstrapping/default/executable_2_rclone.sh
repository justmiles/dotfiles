#!/bin/bash

source "$(dirname $0)/../_utility.sh"
exit_if_installed rclone

set -e

# download and extract rclone
curl -sfLo - https://downloads.rclone.org/rclone-current-linux-amd64.zip | busybox unzip -qd . -

# install rclone
mv rclone-*/rclone ~/.local/bin/
chmod +x ~/.local/bin/rclone

# install manpage
mkdir -p ~/.local/share/man/man1/
mv rclone-*/rclone.1 ~/.local/share/man/man1/
mandb
