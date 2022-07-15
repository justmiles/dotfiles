awssso() {
  # requires:
  # - aws cli v2

  if [[ -z "$AWS_CONFIG_FILE" ]]; then
    local AWS_CONFIG_FILE=~/.aws/config
  fi

  export AWS_PROFILE=${1}
  export AWS_REGION=$(cat ${AWS_CONFIG_FILE} | grep -A20 "$AWS_PROFILE" | grep sso_region | awk '{print $3}' | head -1)
  export AWS_ACCOUNT=$(cat ${AWS_CONFIG_FILE} | grep -A20 "$AWS_PROFILE" | grep sso_account_id | awk '{print $3}' | head -1)

  # Login only if there is no active sso session for the specified profile
  aws sts get-caller-identity >/dev/null 2>&1
  if [ ! $? -eq 0 ]; then
    aws sso login --profile ${AWS_PROFILE}
  fi
}

_awssso() {
  local cur
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}

  if [[ -z "$AWS_CONFIG_FILE" ]]; then
    local AWS_CONFIG_FILE=~/.aws/config
  fi

  WORDS="$(cat ${AWS_CONFIG_FILE} | grep "^\[profile " | sed 's/\[profile //;s/\]//')"
  case "$cur" in
  *)
    COMPREPLY=($(compgen -W "$WORDS" -- "$cur"))
    ;;
  esac
}

complete -F _awssso awssso

awssso-logout() {
  aws sso logout --profile ${AWS_PROFILE}
  unset AWS_PROFILE
  unset AWS_REGION
  unset AWS_ACCOUNT
}

awssso-get-credentials() {
  SSO_ROLE_NAME=$(aws configure get sso_role_name)
  SSO_ACCOUNT_ID=$(aws configure get sso_account_id)
  SSO_START_URL=$(aws configure get sso_start_url)
  TOKEN=$(cat ~/.aws/sso/cache/*.json | jq -rs --arg SSO_START_URL "$SSO_START_URL" '.[] | select(.startUrl == $SSO_START_URL) | .accessToken')
  AUTH=$(aws sso get-role-credentials --role-name "$SSO_ROLE_NAME" --account-id "$SSO_ACCOUNT_ID" --access-token "$TOKEN")

  cat <<EOF
export AWS_DEFAULT_REGION=$(aws configure get region)
export AWS_ACCESS_KEY_ID=$(echo "$AUTH" | jq -r '.roleCredentials.accessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo "$AUTH" | jq -r '.roleCredentials.secretAccessKey')
export AWS_SESSION_TOKEN=$(echo "$AUTH" | jq -r '.roleCredentials.sessionToken')
EOF

}

awssso-get-token() {
  SSO_START_URL=$(aws configure get sso_start_url)
  cat ~/.aws/sso/cache/*.json | jq -rs --arg SSO_START_URL "$SSO_START_URL" '.[] | select(.startUrl == $SSO_START_URL) | .accessToken'
}

awssso-populate-org-profiles() {
  echo "You're looking for the awsorg* commands, dumbass."
}
