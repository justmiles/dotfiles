export AWS_ORG_PREFIX=config-

awsorg() {
  local org=$1

  if [[ -z "$org" ]]; then
    unset AWS_ORG
    unset AWS_CONFIG_FILE
    unset AWS_SHARED_CREDENTIALS_FILE
    unset AWS_DEFAULT_SSO_START_URL
    unset AWS_DEFAULT_SSO_REGION

  else
    export AWS_ORG=$org
    export AWS_CONFIG_FILE=~/.aws/config-$org
    export AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials-$org
    export AWS_DEFAULT_SSO_START_URL=https://$org.awsapps.com/start
    export AWS_DEFAULT_SSO_REGION=us-east-1
  fi
}

_awsorg() {
  local cur
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  WORDS="$(ls ~/.aws/ | grep ${AWS_ORG_PREFIX})"
  WORDS=${WORDS//${AWS_ORG_PREFIX}/}
  case "$cur" in
  *)
    COMPREPLY=($(compgen -W "$WORDS" -- "$cur"))
    ;;
  esac
}

complete -F _awsorg awsorg

awsorg-add() {
  touch ~/.aws/${AWS_ORG_PREFIX}${1}
}

awsorg-rm() {
  rm ~/.aws/${AWS_ORG_PREFIX}${1}
}

awsorg-populate-profiles() {
  aws-sso-util configure populate -u https://${AWS_ORG}.awsapps.com/start --sso-region us-east-1 --region us-east-1 -c output=json --no-credential-process
}

complete -F _awsorg awsorg-rm
