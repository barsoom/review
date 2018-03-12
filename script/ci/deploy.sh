#!/bin/bash

set -e

app_name=$1

function _main {
  _deploy_to_heroku
}

function _deploy_to_heroku {
  set +e
  git remote add heroku https://git.heroku.com/$app_name.git 2> /dev/null

  # Workaround for https://github.com/travis-ci/dpl/issues/127#issuecomment-42397378
  git fetch --unshallow 2> /dev/null
  set -e

  git push heroku master
}

_main
