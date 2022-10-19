source "$(dirname $0)/_utility.sh"

# limit this to desktop environments
exit_if_not_desktop

exit_if_installed slack

set -e

if [ "$OS" = "manjaro" ]; then
  yes | yay -S slack-desktop
fi

if [ "$OS" = "fedora" ]; then
  # enable flatpak
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  
  # install slack
  sudo flatpak install -y flathub com.slack.Slack
fi
