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

PHANTOMJS_VERSION=phantomjs-2.1.1-linux-x86_64
PHANTOMJS_PATH=$HOME/$PHANTOMJS_VERSION
PHANTOMJS_SHA="86dd9a4bf4aee45f1a84c9f61cf1947c1d6dce9b9e8d2a907105da7852460d2f"

if [ ! -e $PHANTOMJS_PATH ]; then
  cd ~
  wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOMJS_VERSION.tar.bz2
  echo "$PHANTOMJS_SHA  phantomjs-2.1.1-linux-x86_64.tar.bz2" | sha256sum -c -
  tar xfj $PHANTOMJS_VERSION.tar.bz2
  ln -sf $PHANTOMJS_PATH $HOME/dependencies/phantomjs
fi

# Fetch and compile dependencies and application code (and include testing tools)
export MIX_ENV="test"
cd $HOME/$CIRCLE_PROJECT_REPONAME
mix do deps.get, deps.compile, compile

if [ ! -e _build/.node-fixed ]; then
  # TODO: try other options: https://github.com/phoenixframework/phoenix/issues/1410
  npm install --save-dev babel-preset-es2015 && touch _build/.node-fixed

  echo
  echo "Running brunch build for the first time, this can take several minutes."
  echo
fi
