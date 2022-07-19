#!/bin/bash

export OS=$(cat /etc/os-release | grep "^ID=" | awk -F '=' '{print $2}')

find ~/.local/share/bootstrapping -type f | xargs -I % basename % | grep -v "^_" | while read script; do
    bash -c "~/.local/share/bootstrapping/$script"
done