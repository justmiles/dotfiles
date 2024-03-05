## remoteChefClient
#
# Usage
#   remoteChefClient <query> - execute chef-client on all nodes matching a Chef node query. Chef-Client are sent to /tmp directory
#   remoteChefClientApp <environemnt> <app> - execute chef-client against all apps in a specific environment
# 
# Examples
#   remoteChefClient chef_environment:corp-qa
#   remoteChefClient fqdn:c15v109*
#   remoteChefClientApp corp-qa targeting
#
# Requirements
#   chefdk, jq
#
# Configuration
#   PASSWORD - your ssh password
#

function remoteChefClient() {
  if [ -z "$PASSWORD" ]; then
    echo "PASSWORD not set!"
    echo "export PASSWORD=... to continue"
    return
  fi
  for host in $(knife search node "$@" --format json | jq '.rows[].automatic.fqdn' | sed 's/"//g'); do
    echo Executing chef-client on $host
    ssh -t $host "unset HISTFILE && echo '$PASSWORD' | sudo -S chef-client" | tee /tmp/$host-chef-client.log
  done

}

function uploadKeysToChef() {
  RED='\033[0;31m'
  GREEN='\033[0;32m'

  for host in $(knife search node "chef_environment:amazon-uat" --format json | jq '.rows[].automatic.fqdn' | sed 's/"//g'); do
    sshpass -p $PASSWORD ssh -t $host "mkdir -p ~/.ssh; chmod 700 ~/.ssh" && echo -e "${GREEN}[$host] created directories" || echo -e "${RED}[$host] failed to create directories" && continue
    sshpass -p $PASSWORD scp ~/.ssh/authorized_keys $host:~/.ssh/authorized_keys && echo -e "${GREEN}[$host] uploaded authorized_keys" || echo -e "${RED}[$host] failed to upload authorized_keys" && continue
    sshpass -p $PASSWORD ssh -t $host "chmod 600 ~/.ssh/authorized_keys" && echo -e "${GREEN}[$host] updated permissions" || echo -e "${RED}[$host] failed to update permissions" && continue
  done

}

function remoteChefClientApp() {
  remoteChefClient "chef_environment:$1 AND (roles:*$2* OR recipes:*$2*)"
}

function kitchen() {
  time /usr/bin/kitchen "$@"
  [ "$?" = 0 ] \
    && notify-send "kitchen $@ finished successfully" -i /usr/share/icons/Mint-X/actions/48/dialog-ok.png \
    || notify-send "kitchen $@ effing failed" -i /home/justmiles/Desktop/27184-200.png
}

function showFailingChefNodes {
  old=$(expr $(date +%s) - 3600)
  knife search node "ohai_time:[0 TO $old]" --format json | jq -r '.rows[].name'
}

alias chef-init='eval "$(chef shell-init zsh)"'

function setChefHost() {
  source ~/.chef/configs/$1.sh
}

_setChefHost() { #  By convention, the function name #+ starts with an underscore.
  local cur
  # Pointer to current completion word.
  # By convention, it's named "cur" but this isn't strictly necessary.

  COMPREPLY=() # Array variable storing the possible completions.
  cur=${COMP_WORDS[COMP_CWORD]}
  WORDS=$(ls -a ~/.chef/configs/*.sh | xargs -n1 basename | sed 's/.sh$//')
  case "$cur" in
    *)
      COMPREPLY=($(compgen -W "$WORDS" -- "$cur"))
      ;;
  esac
}

complete -F _setChefHost setChefHost

function listapps() {
  knife search node "roles:*$1* AND chef_environment:*$2*"
}
