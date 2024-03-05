# if tilix is installed and we're in a tilix session
if [ $TILIX_ID ] || [ $VTE_VERSION ] && [ -e /etc/profile.d/vte.sh ]; then
  source /etc/profile.d/vte.sh
fi
