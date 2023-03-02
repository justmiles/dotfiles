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


# Intall tilix
is_installed tilix || sudo apt install -y tilix

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

# Install VSCode
is_installed code || (
    sudo apt install software-properties-common apt-transport-https wget -y
    sudo wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt-get update
    sudo apt-get install -y code
    # Install extensions
    for item in \
        golang.go \
        hashicorp.terraform \
        ms-python.python \
        redhat.java \
        esbenp.prettier-vscode \
        redhat.vscode-yaml \
        jkillian.custom-local-formatters \
        eamodio.gitlens \
        jebbs.plantuml \
        pkief.material-icon-theme \
        zhuangtongfa.Material-theme \
        tabnine.tabnine-vscode
    do code --force --install-extension $item; done
)

