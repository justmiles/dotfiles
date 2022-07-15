#!/bin/bash

[ -f ~/.local/bin/aws_zsh_completer.sh ] && source ~/.local/bin/aws_zsh_completer.sh

function do_mfa() {
  CREDS=$(aws sts get-session-token --serial-number arn:aws:iam::$AWS_ACCOUNT_ID:mfa/$AWS_USER_ID --token-code $1)
  if [ ! -z "$CREDS" ]; then
    cat <<EOF >~/.aws/env_${AWS_ACCOUNT_ID}
export AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r '.Credentials.AccessKeyId')
export AWS_SESSION_TOKEN=$(echo $CREDS | jq -r '.Credentials.SessionToken')
export AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r '.Credentials.SecretAccessKey')
EOF
  fi
  source ~/.aws/env_${AWS_ACCOUNT_ID}
}

function getUserSessions() {
  aws logs describe-log-streams \
    --log-group-name /aws/sessions \
    --log-stream-name-prefix $1 | jq -r '.logStreams[] | (.firstEventTimestamp | tostring) + " " + .logStreamName' | sort
}

# Launch a new AWS session
newAwsSession() {

  # if already using a session token, pass that
  export AWS_SESSION_TOKEN=$(aws configure get aws_session_token) 2>/dev/null
  if [ ! -z "$AWS_SESSION_TOKEN" ]; then
    export AWS_DEFAULT_REGION=$(aws configure get region)
    export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
    export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
  else
    AUTH=$(aws sts get-session-token | jq -rc '')
    if [ ! -z "$AUTH" ]; then
      export AWS_DEFAULT_REGION=us-east-1
      export AWS_ACCESS_KEY_ID=$(echo $AUTH | jq -r '.Credentials.AccessKeyId')
      export AWS_SESSION_TOKEN=$(echo $AUTH | jq -r '.Credentials.SessionToken')
      export AWS_SECRET_ACCESS_KEY=$(echo $AUTH | jq -r '.Credentials.SecretAccessKey')
      echo "Session created with access key $AWS_ACCESS_KEY_ID"
      echo "This expires $(echo $AUTH | jq -r '.Credentials.Expiration')"
      unset AWS_PROFILE AUTH
    fi

  fi

  # Write to file if passed
  [ ! -z "$1" ] && printenv | grep AWS >$1
}

# Launch a new AWS session
printAWSSession() {
  cat <<EOF
export AWS_DEFAULT_REGION=$(aws configure get region)
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
export AWS_SESSION_TOKEN=$(aws configure get aws_session_token)
EOF
}

function load_aws_token() {
  find ~/.aws/env_${AWS_ACCOUNT_ID} -mmin -720 | egrep '.*' >/dev/null
  if [ "$?" -eq "0" ]; then
    source ~/.aws/env_${AWS_ACCOUNT_ID}
  else
    echo "$AWS_PROFILE AWS token has expired"
  fi
}

function logs() {
  export AWS_REGION=us-east-1
  since=${3:-"5m"}
  echo "cwlogs fetch /$1/ecs/$2 -f -o \"{{ .Message }}\" --since $since"
  cwlogs fetch /$1/ecs/$2 -f -o "{{ .Message }}" --since $since
}

function rdp() {
  xfreerdp /u:"Administrator" /cert-ignore /v:$1:3389 +clipboard +window-drag /t:$1 /w:1920 /h:1060
}

# ec2-clone-instance InstanceId <ImageId>
#   InstanceId  - the instance you want to clone
#   ImageId     - the AMI you want to launch. Defaults to the provided instance's image ID.
function ec2-clone-instance() {
  SOURCE_INSTANCE=$1
  SOURCE_AMI=$(aws ec2 describe-instances --instance-ids $SOURCE_INSTANCE --query 'Reservations[].Instances[].ImageId' --output text)
  SOURCE_PRIVATE_KEY=$(aws ec2 describe-instances --instance-ids $SOURCE_INSTANCE --query 'Reservations[].Instances[].KeyName' --output text)
  SOURCE_SECURITY_GROUP=$(aws ec2 describe-instances --instance-ids $SOURCE_INSTANCE --query 'Reservations[].Instances[].SecurityGroups[].GroupId' --output text)
  SOURCE_INSTANCE_TYPE=$(aws ec2 describe-instances --instance-ids $SOURCE_INSTANCE --query 'Reservations[].Instances[].InstanceType' --output text)
  SOURCE_SUBNET=$(aws ec2 describe-instances --instance-ids $SOURCE_INSTANCE --query 'Reservations[].Instances[].SubnetId' --output text)

  echo "aws ec2 run-instances --image-id $SOURCE_AMI --key-name $SOURCE_PRIVATE_KEY --security-group-ids $SOURCE_SECURITY_GROUP --instance-type $SOURCE_INSTANCE_TYPE --SOURCE_SUBNET-id $SOURCE_SUBNET"
}

# aws-paginated
#   usage: aws-paginated <any aws cli command>
#   requirements: aws-cli, jq
#
function aws-paginated() {
  AWS_CLI_COMMAND="${@}"
  OUTPUT=$(mktemp)

  function _invoke() {
    TMP_OUTPUT=$(mktemp)
    if [ -z "$NEXT_TOKEN" ]; then
      eval "aws $AWS_CLI_COMMAND --output json" >$TMP_OUTPUT
    else
      eval "aws $AWS_CLI_COMMAND --output json --next-token '$NEXT_TOKEN'" >$TMP_OUTPUT
    fi
    cat $TMP_OUTPUT | jq -c 'del(.NextToken)' >>$OUTPUT
    jq -r ".NextToken" $TMP_OUTPUT
    rm $TMP_OUTPUT
  }

  NEXT_TOKEN=$(_invoke $NEXT_TOKEN)
  while [ ! -z "$NEXT_TOKEN" ]; do
    NEXT_TOKEN=$(_invoke $NEXT_TOKEN)
  done

  cat $OUTPUT | jq -s '{PaginatedResults: .}'
  rm -rf $OUTPUT
}
