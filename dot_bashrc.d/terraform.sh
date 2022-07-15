
function terraboard() {
  # newAwsSession

  # export PASSWORD=$(pwgen -1)
  docker run -d --rm --name terraboarddb \
    -e POSTGRES_USER=gorm \
    -e POSTGRES_DB=gorm \
    -e POSTGRES_PASSWORD="XXXXXXXXXXXX" \
    postgres

  docker run -p 8080:8080 \
    -e AWS_REGION="us-east-1" \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_SESSION_TOKEN \
    -e AWS_BUCKET="XXXXXX" \
    -e AWS_FILE_EXTENSION="" \
    -e DB_PASSWORD="XXXXXXXXXXXX" \
    -e DB_NAME="gorm" \
    --link terraboarddb:db \
    camptocamp/terraboard:latest

}

function terraformVersion() {
  VERSION="$1"
  FILE=$(mktemp)
  curl -L https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip -o $FILE
  sudo unzip -o $FILE -d /usr/bin
  rm -rf $FILE
}

function copyTerraformWorkspace() {
  rsync -a workspaces/$2/$1/* workspaces/$3/$1
  echo "workspaces/$3/$1"
}
