# Exremit

Exploring the phoenix and elm based development by reimplementing [remit](github.com/henrik/remit).

# TODO

* [ ] Import data on heroku and test the model layer code
* [ ] Set up ELM
* [ ] Set up client side testing tools
* [x] Look into full stack javascript testing for overall acceptance test (not required, but good to know how)
  * [ ] Get CI working including js tests https://circleci.com/gh/joakimk/exremit/4
* [ ] Token auth in prod

# Load data dump from regular remit

    heroku pg:backups capture -a remit-cr
    curl --output /tmp/data.dump `heroku pg:backups public-url -a remit-cr`
    mix ecto.create
    pg_restore --no-acl --no-owner -d exremit_dev /tmp/data.dump

# Commands used to deploy to heroku

    heroku apps:create exremit --region eu
    heroku buildpacks:set https://github.com/gjaldon/phoenix-static-buildpack
    heroku buildpacks:add --index 1 https://github.com/HashNuke/heroku-buildpack-elixir
    heroku config:set SECRET_KEY_BASE=$(elixir -e "IO.puts :crypto.strong_rand_bytes(64) |> Base.encode64")
    heroku config:set USER_TOKEN=$(elixir -e "IO.puts Regex.replace(~r/[^a-zA-Z0-9]/, (:crypto.strong_rand_bytes(64) |> Base.encode64), \"\")")
    git push heroku

# Running tests

    mix deps.get
    phantomjs -w # in another tab
    mix test
