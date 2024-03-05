function sandbox {
  docker run \
    --rm \
    -e DISPLAY \
    -e USER_ID=$(id -u) \
    -e GROUP_ID=$(id -g) \
    -e DOCKER_GROUP_ID=$(getent group docker | cut -d: -f3) \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $PWD:/home/developer/workspace \
    justmiles/sandbox
}
