# Exremit

Exploring phoenix and elm based development by reimplementing [remit](github.com/henrik/remit).

# TODO

## Bootstrap tools

* [x] Set up client side testing tools **skipped** (since there is no simple setup available, and acceptance tests will probably be good enough for a small app like this)
  * For later: look in http://brunch.io/skeletons.html, and then blog or gist a basic phoenix js testing setup.
* [x] Look into full stack javascript testing for overall acceptance test (not required, but good to know how)
  * [x] Get CI working including js tests https://circleci.com/gh/joakimk/exremit/4
  * [x] Add CI deploy step
* [x] Document dev usage
* [x] Set up ELM
* [x] Token auth in prod

## Building the app

* [x] Render listing of commits
* [x] Add css
* [x] Unbreak CI
  * [ ] try other options for babel-preset if it works
* [ ] Calculate gravatar base url server side for simplicity?
* [ ] Convert config to coffee script for less noisy config
* [ ] Add complete markup from react prototype and see if anything is missing from angular
* [ ] Set up instructions from scratch, bootstrapping scripts, etc
  * [ ] Rewrite instructions in more of a step-by-step start phoenix, start phantom, etc.
    - Possibly make phantomjs part of the phoenix.server in dev.

## Later

* [ ] Pull request to elm-brunch to add custom path to elm binary so we can remove `source web/elm/paths.env` when running `mix phoenix.server`

# Running tests

Install dependencies:

    npm install
    mix deps.get

Start headless browser in another terminal window:

    phantomjs -w

Run tests:

    mix test

If the tests does not pass, start the web server `mix phoenix.server` once so that assets are built. `node_modules/.bin/brunch build` does not seem to work in all cases.

# Running in dev

First load data dump:

    heroku pg:backups capture -a your-remit
    curl --output /tmp/data.dump `heroku pg:backups public-url -a your-remit`
    mix ecto.create
    pg_restore --no-acl --no-owner -d exremit_dev /tmp/data.dump

Then start the server:

    # Since we install elm locally to be able to lock down the version for this project,
    # we need to load it into path so that elm-brunch can find it.
    source web/elm/paths.env

    npm install
    mix phoenix.server
    # open http://localhost:4000

The server also runs assets compilation for development including the elm compiler when saving. It also triggers a refresh of the browser on any change.

# Troubleshooting

If you have problems with javascript tools, you can try reinstalling them using `rm -rf node_modules && npm install`.

# Installing an elm package or running other elm tools

    cd web/elm
    source paths.env
    elm package install name

# Load data dump from regular remit

    heroku pg:backups capture -a your-remit
    curl --output /tmp/data.dump `heroku pg:backups public-url -a your-remit`
    mix ecto.create
    pg_restore --no-acl --no-owner -d exremit_dev /tmp/data.dump

# Commands used to deploy to heroku

    heroku apps:create exremit --region eu
    heroku buildpacks:set https://github.com/gjaldon/phoenix-static-buildpack
    heroku buildpacks:add --index 1 https://github.com/HashNuke/heroku-buildpack-elixir
    heroku config:set SECRET_KEY_BASE=$(elixir -e "IO.puts :crypto.strong_rand_bytes(64) |> Base.encode64")
    heroku config:set USER_TOKEN=$(elixir -e "IO.puts Regex.replace(~r/[^a-zA-Z0-9]/, (:crypto.strong_rand_bytes(64) |> Base.encode64), \"\")")
    git push heroku
