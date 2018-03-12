#!/bin/bash

# Script to report build status to pipeline (a dashboard for CI status)
# See more at: https://github.com/barsoom/pipeline

build_name=$1
command_to_run=$2

# Shortcut to just run the build command if pipeline is not configured
if [[ ! -v "PIPELINE_API_TOKEN" ]]; then
  $command_to_run || exit 1
  exit 0
fi

function _main {
  # Report start of build
  _post_build_status "building"

  # Execute build command
  $command_to_run

  # Report if the build succeeded of failed
  if [[ $? == 0 ]]; then
    _post_build_status "successful"
  else
    _post_build_status "failed"
    exit 1
  fi
}

function _post_build_status {
  curl --request POST "$PIPELINE_BASE_URL/api/build_status" --data "token=$PIPELINE_API_TOKEN&name=$build_name&repository=git@github.com:$CIRCLE_PROJECT_USERNAME/${CIRCLE_PROJECT_REPONAME}.git&revision=$CIRCLE_SHA1&status_url=https://circleci.com/gh/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/$CIRCLE_BUILD_NUM&status=$1"
}

_main
