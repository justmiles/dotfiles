#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed textql

bash -c "$(dirname $0)/go.sh"

go install github.com/dinedal/textql/...@latest
