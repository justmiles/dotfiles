# Copy and paste ENV from a Dockerfile
function ENV() {
  export $1=$2
}

function ducker() {
  if [ "$1 $2" == "rm -a" ]; then
    docker rm -f $(docker ps -a -q)
  else
    docker $@
  fi
}
function dockerRMExited() {
  docker rm $(docker ps -a | grep "Exited" | awk '{print $1}')
}
function dockerRMI() {
  docker rmi -f $(docker images | grep "<none>" | awk '{print $3}')
}

# alias dockerLoginECR='bash -c "$(aws ecr get-login --region us-east-1 --no-include-email)"'

function dockerLoginECR() {
  ACCOUNT=$(aws sts get-caller-identity --query 'Account' --output text)
  REGION=$(aws configure get region)
  aws ecr get-login-password | docker login --username AWS --password-stdin ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com
}
