#!/bin/bash

function loadProfile() {
    system=$1
    echo "Loading system $1"
    find ~/.local/share/bootstrapping/$system -type f | xargs -I % basename % | sort | grep -v "^_" | while read script; do
        bash -c "~/.local/share/bootstrapping/$system/$script"
    done
}

# Load the default profile
loadProfile default

# Load the Manjaro profile
[ "$(cat /etc/os-release | grep "^ID=" | awk -F '=' '{print $2}')" = "manjaro" ] && loadProfile manjaro

# Load the Linux Mint profile
[ "$(cat /etc/os-release | grep "^NAME" | awk -F '=' '{print $2}' | sed 's/"//g')" = "Linux Mint" ] && loadProfile mint
