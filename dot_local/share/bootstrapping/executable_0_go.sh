#!/bin/bash

source "$(dirname $0)/_utility.sh"
exit_if_installed go

set -e

curl -sLo - https://go.dev/dl/go1.18.3.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
echo 'export PATH=$PATH:/usr/local/go/bin:/root/go/bin:$HOME/go/bin' | sudo tee /etc/profile.d/go.sh

source /etc/profile.d/go.sh

# Install go dev tools

go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.46.1
go install github.com/abice/go-enum@latest
go install golang.org/x/tools/gopls@latest
go install github.com/hashicorp/hcl/v2/cmd/hclfmt@latest
