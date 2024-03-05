function dockerRMExited() {
  docker rm $(docker ps -a | grep "Exited" | awk '{print $1}')
}

function dockerRMI() {
  docker rmi -f $(docker images | grep "<none>" | awk '{print $3}')
}

function dockerLoginECR() {
  ACCOUNT=$(aws sts get-caller-identity --query 'Account' --output text)
  REGION=$(aws configure get region)
  aws ecr get-login-password | docker login --username AWS --password-stdin ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com
}
