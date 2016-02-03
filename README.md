# Exremit

Exploring phoenix and elm based development by reimplementing [remit](github.com/henrik/remit).

# TODO

## Bootstrap tools

* [x] Set up client side testing tools **skipped since there is no simple setup available and this app does not strictly needed them (as full stack test will be few and fast too and it's not expected to grow), will research more for later apps, or simply later**
* [x] Look into full stack javascript testing for overall acceptance test (not required, but good to know how)
  * [x] Get CI working including js tests https://circleci.com/gh/joakimk/exremit/4
  * [ ] Add CI deploy step
* [ ] Set up ELM
* [ ] Token auth in prod
* [ ] Document dev usage

## Building the app

* [ ] Render listing of commits

# Running tests

    mix deps.get
    phantomjs -w # in another tab
    mix test

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
