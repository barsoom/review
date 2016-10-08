***Status***: A few more things is needed before it's usable, see todos.

# Review

Review is a web app for commit-by-commit code review of GitHub repositories. A modern, live UI thanks to Elixir/Phoenix and Elm.

It's super easy to set up on a free Heroku instance.

Keeps track of what has been reviewed and links to GitHub commits for the actual review.

Also tracks comments on commits.

[Demo app on heroku](https://review-on-review.herokuapp.com/?auth_key=demo)

## History

Review was built to explore how practical it was to build applications in Elixir/Phoenix and Elm. Review is a reimplementation of [remit](https://github.com/henrik/remit), which in turn was inspired by [hubreview](https://github.com/joakimk/hubreview).

## TODO

### Remaining todos before we can use this :)

* Workflow
  * [x] Test and write backend for comment buttons
* Github hooks
  * [x] Add websocket handing of new commits/comments
  * [x] Deploy review-on-review on heroku
  * [x] Connect github hooks to the demo app and the production app
  * [x] Add github hook for ping
  * [x] Add github hook for comments
  * [x] Add github hook for commits
    - [x] Ignore non-master commits
* Minor missing UI
  * [x] Add commits-to-review-count text and links on commits page
  * [x] Add all-commits-reviewed-banner
  * [x] Add all-comments-resolved-banner
  * [x] Fix styling differences, if any
  * [x] If there is time: Only open links on clicking outside of buttons or start review
    - Slightly tricky to do, in Elm it seems better to handle all that using Cmd's rather than disabling other events onClick
* API
 * [x] Unreviewed commits API for our internal dashboard `/api/v1/unreviewed_commits` returns `{ count: 1/0, oldest_age_in_seconds: 1/nil }`, see <https://github.com/henrik/remit/blob/master/app/controllers/api/v1/unreviewed_commits_controller.rb>
* [x] Set maintenance on remit, copy the database to review, set `REDIRECT_TO_OTHER_REMIT_URL` on remit to redirect to review.

### Later

* [ ] Be able to hide reviewed commits?
* [ ] Find out how to handle dates in tests properly for the api tests
* [ ] Attempt to fetch more info on authors when comments arrive and we don't already have their name/email.
* [ ] Add proper getting started docs and example install like remit has
* [ ] Limit auto-reload on deploy as much as possible (e.g. only on data format or client code changes)
* [ ] Use shasum checking for downloads in CI
* [ ] Figure out how to test the auth\_key check in UserSocket
* [ ] Possibly make phantomjs part of the phoenix.server in dev
* [ ] Cache the last build step
* [ ] Maybe: Extract a mix package for `render_elm` and maybe a npm for the ujs, or remove both
* [ ] Display gravatar in settings (didn't do it to start with since we have no other js gravatar code yet and it's not strictly needed)

### Make the tools better

* [ ] render\_elm is a bit problematic as it does not happen at js-time so local storage or cookies can't be loaded
* [ ] follow up the [elm-brunch discussion](https://github.com/madsflensted/elm-brunch/pull/14) on what changes to make
* [ ] Look into using [node-elm-compiler](https://github.com/rtfeldman/node-elm-compiler) in elm-brunch
* [ ] Figure out why prod sometimes tries to use the non-digested app.js name

### Collect info on how to work with Phoenix and Elm in one place

There is already blog posts, but haven't found anything that describes a development enviornment that works as well as something like react / rails. Might write one based on this.

* [ ] Write down ideas for a blog post or gist or something
* [ ] Finish up tools (elm-phoenix, elm-brunch, elm-phoenix-ujs)
* [ ] Figure out a good way to do unit testing

## Development

### Installing or updating dependencies

    script/bootstrap

### Loading data for dev

    script/download_and_import_database your-review-or-remit-app-name

### Copy data from one remit installation to another

Can be used to copy from remit to review, or just to copy data between two deploys of the same type.

    script/copy_data_between_remit_deploys remit-app review-app

### Dumping schema to priv/repo/structure.sql

They way we've disabled logging in dev isn't compatible with most other commands, so you need to run `ENABLE_DB_LOGGING=true mix ecto.dump` to dump schema.

### Running tests

Start headless browser in another terminal window:

    phantomjs -w

Run tests:

    mix test

### Developing

If you use a editor plugin to issue a test command in a separate console, you can use `test_server` to do handle both that and run the phoenix.server in the same console window.

**Important:** If you get a compile error that should not happen it's very likely this is some kind of caching issue in brunch, restart the `test_server
`. Another, but very unlikely error could be a cache issue in elm, then you have to remove `web/elm/elm-stuff/build-artifacts`.

    source web/elm/paths.env
    mix test_server

Otherwise, start a phoenix.server in a separate console to get a dev server and build Elm code when it changes.

    mix phoenix.server

And run tests somewhere else.

### Installing an elm package or running other elm tools

    cd web/elm
    source paths.env
    elm package install name

### Troubleshooting

If you have problems with the dependencies, elixir, javascript or elm, try running `script/clean` and then `script/bootstrap` to reinstall all of it.

### Commands used to deploy to heroku

    heroku apps:create review --region eu
    heroku buildpacks:set https://github.com/gjaldon/phoenix-static-buildpack
    heroku buildpacks:add --index 1 https://github.com/HashNuke/heroku-buildpack-elixir
    heroku config:set SECRET_KEY_BASE=$(elixir -e "IO.puts :crypto.strong_rand_bytes(64) |> Base.encode64")
    heroku config:set AUTH_KEY=$(elixir -e "IO.puts Regex.replace(~r/[^a-zA-Z0-9]/, (:crypto.strong_rand_bytes(64) |> Base.encode64), \"\")")
    heroku labs:enable runtime-dyno-metadata
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
