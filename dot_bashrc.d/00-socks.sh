# Kill Socks5 process
# killSocks <port>
function killSocks() {
  SSH=autossh
  for PID in $(ps aux | grep "ssh.*-N -D 127.0.0.1" | grep $1 | grep -v grep | awk '{print $2}'); do
    kill -9 $PID 2>/dev/null
  done
}

function getAllSocks() {
  (echo -e "HOST \t PORT"
  SSH=autossh
  for PORT in $(netstat -tlpn 2>/dev/null | grep -v autossh | grep ssh | grep -o "0 127.0.0.1:10[0-9]*" | awk -F ':' '{print $2}'); do
    PID=$(netstat -tlpn 2>/dev/null | grep "127.0.0.1:$PORT" | grep -o "[0-9]*/ssh" | sed 's/\/ssh//')
    if [ ! -z "$PID" ]; then
      HOST=$(ps -o cmd= -p $PID | awk '{print $(NF)}')
      echo -e "$HOST \t $PORT" 
    fi
  done) | column -t
}

# Create Socks5 forward.
function createSocksProxy() {
  
  if [ -f /usr/bin/autossh ]; then
    SSH_BIN=/usr/bin/autossh
  else
    SSH_BIN=/usr/bin/ssh
  fi
  
  if [ -z "$2" ]; then
    PORT=1080
  else
    PORT=$2
  fi
    
  killSocks $PORT
  
  $SSH_BIN -f -N -D 127.0.0.1:$PORT $1
}

function socks() {
  read -r -d '' USAGE << EOM
    
  Usage: socks [options] [command]
  
  Commands:

    <hostname>		Create a connection to a host.

  Options:

    -c, --host		Remote host to tunnel traffic through
    -p, --port		Local port to tunnel traffic through. Defaults to 1080
    -k, --kill		Kill a socks tunnel by passing the proxy port
    -l, --list		Lists all proxies
    -h, --help		output usage information

EOM
  
  # Defaults
  PORT=1080
  HOST=$1
  
  while [[ $# -gt 0 ]]
  do
  key="$1"

  case $key in
      -p|--port)
      PORT="$2"
      shift
      ;;
      -c|--host)
      HOST="$2"
      shift
      ;;
      -k|--kill)
      killSocks $2
      getAllSocks
      return
      ;;
      -l|--list)
      getAllSocks
      return
      ;;
      -h|--help)
      echo "$USAGE"
      return
      ;;
      --default)
      DEFAULT=YES
      ;;
      *)
              # unknown option
      ;;
  esac
  shift # past argument or value
  done

  createSocksProxy $HOST $PORT

}

function doSocks() {
  socks -c reverse_backdoor -p 1089
  socks -c bastion -p 1088
  sleep 2
  socks -l
}

# Quick tunnel with the following syntax:
#   tunnel remote_host host port
function tunnel() {
  if [ -z "$4" ]; then
    LOCALPORT=$3
  else
    LOCALPORT=$4
  fi
  echo "Binding local port $LOCALPORT to $2:$3 through the $1 tunnel."
  echo "Command: ssh -f -L $LOCALPORT:$2:$3 $1 -N"
  ssh -f -L $LOCALPORT:$2:$3 $1 -N
}
