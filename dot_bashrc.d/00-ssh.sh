# Functin to upload SSH keys to various servers

function sshinit {
  SSH_SERVER=$1
  SSH_PUBLICKEY_PATH=$2
  SSH_PUBLICKEY=`basename $SSH_PUBLICKEY_PATH`
  KEY=$(cat $SSH_PUBLICKEY_PATH)
  echo "Adding $SSH_PUBLICKEY to authorized_keys"
  ssh $SSH_SERVER "mkdir -p ~/.ssh; chmod 700 ~/.ssh; echo $KEY > ~/.ssh/authorized_keys; chmod 600 ~/.ssh/authorized_keys;cat ~/.ssh/authorized_keys"
}

function uploadkeys {
	sshinit $1
}

function sshsh {
	ssh $1 "bash -s" -- < $2
}

# Description: 
#   takes the xauth key from another use. useful for passing x to root
# Example:
#   takeXFrom miles.maddox
function takeXFrom {
  su - $1 -c 'xauth list' | grep `echo $DISPLAY | cut -d ':' -f 2 | cut -d '.' -f 1 | sed -e s/^/:/` | xargs -n 3 xauth add
}

function remoteSudo {
  host=$1
  echo Executing `$COMMAND` on $host
  ssh -t $host "unset HISTFILE && echo '$PASSWORD' | sudo $COMMAND" | tee /tmp/$host-remoteSudo.log
}

function genSSHConf {
  CONF=~/.ssh/config
  truncate -s 0 $CONF
  
  for config in $(ls ~/.ssh/configs); do
    cat ~/.ssh/configs/$config >> $CONF
  done
  
  chmod 600 $CONF
  for IdentityFile in $(cat ~/.ssh/config | grep IdentityFile | awk '{print $2}' | sort | uniq | sed 's@~@'"$HOME"'@'); do
    if [ -f $IdentityFile ]; then
      chmod 400 $IdentityFile
    else
      echo "missing ssh IdentityFile: $IdentityFile"
    fi
  done
}
