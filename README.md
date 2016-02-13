# Exremit

Exploring phoenix and elm based development by reimplementing [remit](https://github.com/henrik/remit).

# TODO

## Make code review possible

* [ ] Implement completing a review
* [ ] Implement undoing a review
* [ ] Show commits you can review based on who you are
* [ ] Store payload from Github commit
  * [ ] In remit: store "repository" outside of payload so that the commit payload can be stored directly into the db?
  * [ ] Does created\_at and updated\_at get updated by ecto?
* [ ] Consider if temporary state-sync could be setup so both apps could be used at once for a while

## Make the tools better

* [x] Support multiple files in elm-brunch
* [x] assetsmanager makes the live reload run twice
* [x] Explore if a view helper like `<%= render_elm "CommitList", environment: Mix.env, initialCommits: [] %>` is pracical, how to expose a way to handle outgoing commands? Maybe something like `window.elmApps.CommitList.ports.subscribe`?
  - This type of helper does make react feel very easy to use in our rails apps. Like rendering a dynamic partial.
* [ ] follow up the [elm-brunch discussion](https://github.com/madsflensted/elm-brunch/pull/14) on what changes to make
* [ ] Look into using [node-elm-compiler](https://github.com/rtfeldman/node-elm-compiler) in elm-brunch
* [ ] Figure out why prod sometimes tries to use the non-digested app.js name
* [ ] elm-brunch: add custom path to elm binary so we can remove `source web/elm/paths.env` when running `mix phoenix.server`

## More reliable state sync

* [ ] Send entire state when you re-connect, show that this works as it's kind of a killer feature for this version
  * [ ] Does re-connect solve if you're offline for 3 seconds while an update is sent out?

## Make code review fully featured

* [ ] Add any missing behavior from the angular code

## Later

* [x] Convert config to coffee script for less noisy config
* [x] Add a install/update dependencies script
* [x] Set up instructions from scratch, bootstrapping scripts, etc
* [ ] Use shasum checking for downloads in CI
* [ ] Figure out how to test the auth\_key check in UserSocket
* [ ] Possibly make phantomjs part of the phoenix.server in dev
* [ ] Cache the last build step
* [ ] Extract a mix package for `render_elm` and maybe a npm for the ujs

## Collect info on how to work with Phoenix and Elm in one place

There is already blog posts, but haven't found anything that describes a development enviornment that works as well as something like react / rails. Might write one based on this.

* [ ] Write down ideas for a blog post or gist or something
* [ ] Finish up tools (elm-phoenix, elm-brunch, elm-phoenix-ujs)
* [ ] Figure out a good way to do unit testing

# Development

## Installing or updating dependencies

    script/bootstrap

## Loading data for dev

    script/download_and_import_database your-exremit-or-remit-app-name

## Running tests

Start headless browser in another terminal window:

    phantomjs -w

Run tests:

    mix test

## Installing an elm package or running other elm tools

    cd web/elm
    source paths.env
    elm package install name

## Troubleshooting

If you have problems with the dependencies, elixir, javascript or elm, try running `script/clean` and then `script/bootstrap` to reinstall all of it.

## Commands used to deploy to heroku

    heroku apps:create exremit --region eu
    heroku buildpacks:set https://github.com/gjaldon/phoenix-static-buildpack
    heroku buildpacks:add --index 1 https://github.com/HashNuke/heroku-buildpack-elixir
    heroku config:set SECRET_KEY_BASE=$(elixir -e "IO.puts :crypto.strong_rand_bytes(64) |> Base.encode64")
    heroku config:set USER_TOKEN=$(elixir -e "IO.puts Regex.replace(~r/[^a-zA-Z0-9]/, (:crypto.strong_rand_bytes(64) |> Base.encode64), \"\")")
    git push heroku

# License

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
