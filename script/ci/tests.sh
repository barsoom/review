#!/bin/bash

export MIX_ENV="test"
export PATH="$HOME/dependencies/erlang/bin:$HOME/dependencies/elixir/bin:$PATH"

# Start headless browser server used by javascript-enabled acceptance tests
phantomjs -w > /dev/null &
sleep 0.5

mix test
