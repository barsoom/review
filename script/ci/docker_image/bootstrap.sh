#!/bin/sh
set -e

export MIX_ENV=test

# Install package tools
if [ ! -e $HOME/.mix/rebar ]; then
  yes Y | LC_ALL=en_GB.UTF-8 mix local.hex
  yes Y | LC_ALL=en_GB.UTF-8 mix local.rebar
fi


cd /app

mix do deps.get, deps.compile, compile
npm install

export PATH="/app/node_modules/.bin:$PATH"

cd web/elm
elm package install -y
cd ../..

brunch build
