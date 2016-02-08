#!/bin/sh

docker run -v ~/exremit:/app -v ~/.mix:/root/.mix exremit /app/script/ci/docker_image/tests.sh
