#!/usr/bin/env bash

set -eu

dockerfile=$(mktemp)
trap "rm $dockerfile" EXIT
cat << EOF > $dockerfile
FROM ubuntu:bionic

RUN apt-get update \
  && apt-get install -y \
    curl \
    gnupg2 \
  && curl -L https://workspaces-client-linux-public-key.s3-us-west-2.amazonaws.com/ADB332E7.asc | apt-key add - \
  && echo "deb [arch=amd64] https://d3nt0h4h6pmmc4.cloudfront.net/ubuntu bionic main" | tee /etc/apt/sources.list.d/amazon-workspaces-clients.list \
  && apt-get update \
  && apt-get install -y \
    liblttng-ust0 \
    libusb-1.0-0 \
    workspacesclient \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get autoclean \
  && apt-get autoremove

WORKDIR /opt/workspacesclient

ENTRYPOINT [ "/opt/workspacesclient/workspacesclient" ]
EOF

docker build -t aws-workspaces - < $dockerfile
xhost +local:
exec /usr/bin/docker run -i --rm --name aws-workspaces \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v "$HOME/.aws-workspaces":"/root/.local/share/Amazon Web Services" \
  -e DISPLAY \
  aws-workspaces