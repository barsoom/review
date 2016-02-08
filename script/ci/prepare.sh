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
docker run -v ~/exremit:/app -v ~/.mix:/root/.mix exremit /app/script/ci/docker_image/bootstrap.sh

exit 0

if [ ! -e _build/.node-fixed ]; then
  # TODO: try other options: https://github.com/phoenixframework/phoenix/issues/1410
  npm install --save-dev babel-preset-es2015 && touch _build/.node-fixed

  echo
  echo "Running brunch build for the first time, this can take several minutes."
  echo
fi
