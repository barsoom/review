# Exremit

Exploring phoenix and elm based development by reimplementing [remit](https://github.com/henrik/remit).

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

## Make code review possible

* [x] Render listing of commits
* [x] Add css
* [x] Unbreak CI
  * [x] **skip for now** try other options for babel-preset if it works
* [x] Calculate gravatar base url server side for simplicity?
* [x] Add complete markup and behavior from the react prototype
* [x] Add mark as posted button and websockets to update other clients
* [ ] Show commits you can review based on who you are
* [ ] Send entire state when you re-connect, show that this works as it's kind of a killer feature for this version
  * [ ] Does re-connect solve if you're offline for 3 seconds while an update is sent out?
* [ ] Consider if temporary state-sync could be setup so both apps could be used at once for a while

## Make code review fully featured

* [ ] Add any more behavior from the angular code

## Add github hook for commits

* [ ] Store "repository" outside of payload so that they commit payload can be stored directly into the db?

## Later

* [ ] Improve elm-brunch so that the code can be split into several different files
* [ ] Figure out how to test the auth\_key check in UserSocket
* [ ] Add a install/update dependencies script
* [ ] Set up instructions from scratch, bootstrapping scripts, etc
  * [ ] Rewrite instructions in more of a step-by-step start phoenix, start phantom, etc.
    - Possibly make phantomjs part of the phoenix.server in dev.
* [ ] Convert config to coffee script for less noisy config
* [ ] Does created\_at and updated\_at get updated by ecto?
* [ ] Pull request to elm-brunch to add custom path to elm binary so we can remove `source web/elm/paths.env` when running `mix phoenix.server`

# Installing dependencies

    source web/elm/paths.env && npm install && mix deps.get && cd web/elm && elm package install -y && cd ../..

    # start web server and build assets
    mix phoenix.server

# Loading data for dev

    heroku pg:backups capture -a your-remit
    curl --output /tmp/data.dump `heroku pg:backups public-url -a your-remit`
    mix ecto.create
    pg_restore --no-acl --no-owner -d exremit_dev /tmp/data.dump

# Running tests

Start headless browser in another terminal window:

    phantomjs -w

Run tests:

    mix test

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

## License

Copyright (c) 2016 [Auctionet.com](http://dev.auctionet.com/)

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
