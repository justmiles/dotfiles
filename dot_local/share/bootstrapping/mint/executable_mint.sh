#!/bin/bash

set +x

function is_installed(){

   # exec > >(trap "" INT TERM; sed "s/^/${1}: /")
   # exec 2> >(trap "" INT TERM; sed "s/^/${1}: (stderr) /" >&2)

    which $1 > /dev/null 2>/dev/null
    [ $? -eq 0 ] && [ ! "$FORCE_REINSTALL" = "y" ] && return 0
    echo "installing.."

    TMPDIR=$(mktemp -d)
    trap 'cd && rm -rf -- "$TMPDIR"' EXIT
    cd $TMPDIR
    return 1
}

# Intall tilix
is_installed tilix || ( 
    sudo apt install -y tilix
    dconf load /com/gexperts/Tilix/ < ~/.config/tilix.dconf
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

# Install jq
is_installed jq || (
    sudo apt-get install -y jq
)

# Install xclip
is_installed xclip || (
    sudo apt-get install -y xclip
)

# Install xclip
is_installed xclip || (
    sudo apt-get install -y xclip
)

# Install unzip
is_installed unzip || (
    sudo apt-get install -y unzip
)

# Install direnv
is_installed direnv || (
    sudo apt-get install -y direnv
)

# Install docker
is_installed docker || (
    sudo apt-get install -y docker
    sudo systemctl start docker.service
    sudo systemctl enable docker.service
    sudo usermod -aG docker $USER
)

# Install taskwarrior
is_installed task || (
    sudo apt-get install -y taskwarrior
)

# Install slack
is_installed slack || (
    flatpak install -y flathub com.slack.Slack
    cat << EOF > ~/.local/bin/slack
/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=slack --file-forwarding com.slack.Slack
EOF
    chmod +x ~/.local/bin/slack
)

# Install meld
is_installed meld || (
    sudo apt-get install -y meld
)

# Install gopass
is_installed gopass || (
    go install github.com/gopasspw/gopass@latest
)

# Install Typora
is_installed Typora || (

    INSTALL_DIR=~/.local/share/typora
    mkdir -p $INSTALL_DIR
    curl -sfLo - https://typora.io/linux/Typora-linux-x64.tar.gz | tar -xzvf - -C $INSTALL_DIR --strip-components=2
    ln -s ~/.local/share/typora/Typora ~/.local/bin/Typora
    DEST_SHORTCUT="$HOME/.local/share/applications/typora.desktop"
    cat << EOF > $DEST_SHORTCUT
[Desktop Entry]
Name=Typora
Exec=~/.local/share/typora/Typora
Icon=~/.local/share/typora/resources/assets/tile/OD-LargeTile.scale.png
Terminal=false
Type=Application
EOF

)

