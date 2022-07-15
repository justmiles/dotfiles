#!/bin/bash
# ssm
#   Launch console sessions using AWS Simple Systems Manager
# Requirements
#   jq, aws-cli
# Usage
#   ssm <instance name>
#   ssm <instance id>

_ssm() {

  [ -z "$AWS_PROFILE" ] && echo "AWS_PROFILE not set!" && return

  CACHE="/tmp/instances_${AWS_PROFILE}.json"

  find $CACHE -mmin -720 >/dev/null 2>&1 || (aws ec2 describe-instances --filters Name=instance-state-code,Values=16 >$CACHE 2>/dev/null || rm $CACHE)

  # return if cache is empty
  [ ! -f $CACHE ] && echo "err: unable to describe instances" && return

  local cur
  local IFS=$'\n'
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  echo $cur
  WORDS="$(cat $CACHE | jq '.[][].Instances[] | .Tags[] | select(.Key == "Name") | .Value' | sort | uniq)"
  case "$cur" in
  *)
    COMPREPLY=($(compgen -W "$WORDS" -- "$cur"))
    ;;
  esac
}

function ssm() {
  CACHE="/tmp/instances_${AWS_PROFILE}.json"

  TARGET="$@"
  REG="^i-[0-9a-z]+"
  if [[ "$TARGET" =~ $REG ]]; then
    INSTANCE_ID=$TARGET
    TARGET=""
  else
    INSTANCE_ID=$(cat $CACHE | jq -r --arg v "$TARGET" '.[][].Instances[] | (select( .Tags[] | .Value == $v)) | .InstanceId' | shuf -n 1)
  fi

  if [ -z INSTANCE_ID ]; then
    echo "No instance matching '$TARGET'"
    exit 1
  fi

  echo $TARGET $INSTANCE_ID
  aws ssm start-session --target $INSTANCE_ID
}

complete -F _ssm ssm

###############################################
###############################################

_ssm-ecs() {
  # aws ecs list-clusters --query '{ClusterArns: clusterArns}' --output text | awk '{print $2}' | xargs -I % basename % | sort

  local cur
  local IFS=$'\n'
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  echo $cur
  WORDS="$(aws ecs list-services --cluster ops --output text --query '{serviceArns: serviceArns}' | awk '{print $2}' | xargs -I % basename % | sort)"
  case "$cur" in
  *)
    COMPREPLY=($(compgen -W "$WORDS" -- "$cur"))
    ;;
  esac

}

function ssm-ecs() {
  TASK=$(aws ecs list-tasks --cluster ops --service $1 --output text --query 'taskArns[]' | xargs -I % basename %)
  echo "aws ecs execute-command --cluster ops --task $TASK --container $1 --interactive --command bash"
  aws ecs execute-command --cluster ops --task $TASK --container $1 --interactive --command bash
}

complete -F _ssm-ecs ssm-ecs
