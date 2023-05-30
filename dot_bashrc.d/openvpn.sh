function do_vpn() {
  export OPENVPN_PROFILE=${OPENVPN_PROFILE:-"default"}

  if [ -e "$HOME/.openvpn/${OPENVPN_PROFILE}.ovpn" ]; then
    openvpncmd="--config  ~/.openvpn/${OPENVPN_PROFILE}.ovpn"
  else
    echo "Profile ${OPENVPN_PROFILE} not found ($HOME/.openvpn/${OPENVPN_PROFILE}.ovpn)"
    return 1
  fi

  MFA=$(gopass totp --password "$OPENVPN_MFA")
  CREDS=$(mktemp -p ~/)
  chmod 600 $CREDS
  gopass show "$OPENVPN_PASS" >$CREDS

  bash -c "sleep 30; rm -rf $CREDS" &
  sudo ~/.bin/vpn $HOME/.openvpn/$OPENVPN_PROFILE.ovpn $MFA $CREDS
}
