#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed gotop

source /etc/profile.d/go.sh

GOBIN=~/.local/bin go install -v github.com/xxxserxxx/gotop/v4/cmd/gotop@latest
