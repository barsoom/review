# Exremit

Exploring phoenix and elm based development by reimplementing [remit](https://github.com/henrik/remit).

# TODO

## Make code review possible

* [x] Implement completing a review
* [x] Implement undoing a review
* [x] Add settings dialog to save the reviewer email and name, probably in a cookie
* [x] Show commits you can review based on who you are
* [x] Show who reviewed what based on email, and so on
* [x] Make dev elm compilation reliable
* [x] Port to 0.17
* [x] Try having a single main module since other things are shared
* [x] Persist who reviews and who reviewed
* [x] Consider if temporary state-sync could be setup so both apps could be used at once for a while
* [ ] Store payload from Github commit
  * [ ] In remit: store "repository" outside of payload so that the commit payload can be stored directly into the db?
  * [x] Does created\_at and updated\_at get updated by ecto?
* [ ] Auto reload on code changes to keep everyone up to date (as changes will come somewhat often), or a notice that you are behind like trello
  - At the very least keep current tab. Also for regular reloads.

## Make it possible and practial to switch over to this version for normal use

* [ ] Implement the comments page
  - [x] Implement the simplest possible listing
  - [ ] Add `json_payload` to comments in remit and redo data dump.
  - [x] Implement visual things in the listings.
  - [ ] Implement mark as resolved
  - [ ] Implement mark as new
  - [ ] Add github hook for comments
  - [ ] Maybe: Do performance optimizations if it's slow in any way.
* [ ] Add any missing behavior from the angular code
* [ ] Send entire state when you re-connect, [like the welcome hook](https://gist.github.com/joakimk/7b9ed5138c48594f0cdecfe95cb6c41e), show that this works as it's kind of a killer feature for this version
* [ ] NICE: cache the commit serialization (takes 80% of the time)

## More reliable state sync

* [x] Simplify / Usability: Explore the UI-feel when not doing any local updates at all, just displaying the server updates

## Make the tools better

* [x] Support multiple files in elm-brunch
* [x] assetsmanager makes the live reload run twice
* [x] Explore if a view helper like `<%= render_elm "CommitList", environment: Mix.env, initialCommits: [] %>` is pracical, how to expose a way to handle outgoing commands? Maybe something like `window.elmApps.CommitList.ports.subscribe`?
  - This type of helper does make react feel very easy to use in our rails apps. Like rendering a dynamic partial.
* [x] Fix the annoying not-reloading-code-when-error-in-one-of-multiple-files-unless-you-restart-the-server-bug
  - Not 100% fixed, but close.
* [ ] render\_elm is a bit problematic as it does not happen at js-time so local storage or cookies can't be loaded
* [ ] follow up the [elm-brunch discussion](https://github.com/madsflensted/elm-brunch/pull/14) on what changes to make
* [ ] Look into using [node-elm-compiler](https://github.com/rtfeldman/node-elm-compiler) in elm-brunch
* [ ] Figure out why prod sometimes tries to use the non-digested app.js name
* [ ] elm-brunch: add custom path to elm binary so we can remove `source web/elm/paths.env` when running `mix phoenix.server`

## Later

* [x] Convert config to coffee script for less noisy config
* [x] Add a install/update dependencies script
* [x] Set up instructions from scratch, bootstrapping scripts, etc
* [ ] Rename the project, if nothing else then let's call it "review"
- [ ] Have a offline-label displayed by js (or set as elm state?) on send-to-server-errors, and hidden on join?
* [ ] Use shasum checking for downloads in CI
* [ ] Figure out how to test the auth\_key check in UserSocket
* [ ] Possibly make phantomjs part of the phoenix.server in dev
* [ ] Cache the last build step
* [ ] Maybe: Extract a mix package for `render_elm` and maybe a npm for the ujs, or remove both
* [ ] Display gravatar in settings (didn't do it to start with since we have no other js gravatar code yet and it's not strictly needed)

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

## Copy data from one remit installation to another

Can be used to copy from remit to exremit, or just to copy data between two deploys of the same type.

    script/copy_data_between_remit_deploys remit-app exremit-app

## Running tests

Start headless browser in another terminal window:

    phantomjs -w

Run tests:

    mix test

## Developing

If you use a editor plugin to issue a test command in a separate console, you can use `test_server` to do handle both that and run the phoenix.server in the same console window.

    source web/elm/paths.env
    mix test_server

Otherwise, start a phoenix.server in a separate console to get a dev server and build Elm code when it changes.

    mix phoenix.server

And run tests somewhere else.

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
    heroku config:set AUTH_KEY=$(elixir -e "IO.puts Regex.replace(~r/[^a-zA-Z0-9]/, (:crypto.strong_rand_bytes(64) |> Base.encode64), \"\")")
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
