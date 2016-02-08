#!/bin/bash
set -e

if [[ -e ~/docker/exremit.tar ]]; then
  docker load -i ~/docker/exremit.tar
fi

export IMAGE_PATH="$HOME/$CIRCLE_PROJECT_REPONAME/script/ci/docker_image"
cd $IMAGE_PATH

docker build -t exremit .

mkdir -p ~/docker
docker save exremit > ~/docker/exremit.tar

# writes packages and such to the host system so it can be cached
docker run -v ~/exremit:/app -v ~/.mix:/root/.mix exremit /app/script/install_dependencies
