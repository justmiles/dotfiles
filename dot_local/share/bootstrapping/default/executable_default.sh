#!/bin/bash

function is_installed(){
  # exec > >(trap "" INT TERM; sed "s/^/${1}: /")
  # exec 2> >(trap "" INT TERM; sed "s/^/${1}: (stderr) /" >&2)

  which $1 > /dev/null 2>/dev/null
  [ $? -eq 0 ] && [ ! "$FORCE_REINSTALL" = "y" ] && return 0
  echo "installing.."

  TMPDIR=$(mktemp -d)
  trap 'rm -rf -- "$TMPDIR"' EXIT
  cd $TMPDIR
  return 1
}

# Install go
is_installed go || (
  curl -sLo - https://go.dev/dl/go1.18.3.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local \
  && echo 'export PATH=$PATH:/usr/local/go/bin:/root/go/bin:$HOME/go/bin' | sudo tee /etc/profile.d/go.sh \
  && source /etc/profile.d/go.sh \
  && go install github.com/go-delve/delve/cmd/dlv@latest \
  && go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.46.1 \
  && go install github.com/abice/go-enum@latest \
  && go install golang.org/x/tools/gopls@latest \
  && go install github.com/hashicorp/hcl/v2/cmd/hclfmt@latest
)

# Install Athena CLI
is_installed athena || (
  VERSION=$(curl -sfL https://api.github.com/repos/justmiles/athena-cli/releases/latest | jq -r '.tag_name' | sed 's/v//g')
  KERNEL=$(uname -s)
  MACHINE=$(uname -m)
  DOWNLOAD_URL="https://github.com/justmiles/athena-cli/releases/download/v${VERSION}/athena-cli_${VERSION}_${KERNEL}_${MACHINE}.tar.gz"

  curl -sfLo - ${DOWNLOAD_URL,,} | tar -xzf - -C ~/.local/bin athena
)

# Install AWS CLI
is_installed aws || (
    curl -sflo "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install --update
    rm -rf aws awscliv2.zip
)

# Install csvq
is_installed csvq || (
    VERSION=$(curl -sfL https://api.github.com/repos/mithrandie/csvq/releases/latest | jq -r '.tag_name' | sed 's/v//g')
    KERNEL=$(uname -s)
    MACHINE=$(uname -m)
    DOWNLOAD_URL="https://github.com/mithrandie/csvq/releases/download/v${VERSION}/csvq-v${VERSION}-linux-amd64.tar.gz"
    curl -sfLo - $DOWNLOAD_URL | tar -xzf - -C ~/.local/bin --strip-components=1 csvq-v${VERSION}-linux-amd64/csvq
)
