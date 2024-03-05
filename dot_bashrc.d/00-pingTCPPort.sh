function pingTCPPort {
  # pingTCPPort hostname port
  cat < /dev/tcp/$1/$2
}
