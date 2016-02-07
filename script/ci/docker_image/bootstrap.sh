#!/bin/sh
set -e

export MIX_ENV=test

cd /app
mix do deps.get, deps.compile, compile
