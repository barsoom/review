#!/bin/bash

echo "Not running tests yet"

docker run exremit erl -v

exit 0

export MIX_ENV="test"
export PATH="$HOME/dependencies/phantomjs/bin:$HOME/dependencies/erlang/bin:$HOME/dependencies/elixir/bin:$PATH"

# Start headless browser server used by javascript-enabled acceptance tests
phantomjs -w > /dev/null &
sleep 2

mix test
