#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed textql

source /etc/profile.d/go.sh

GOBIN=~/.local/bin go install -v github.com/dinedal/textql/...@latest
