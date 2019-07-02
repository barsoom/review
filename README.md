***Status***: [auctionet devs](http://dev.auctionet.com) has used it for more than a year. It's stable. Some docs and polish would make it easier for others to adopt it.

# Review

Review is a web app for commit-by-commit code review of GitHub repositories. A modern, live UI thanks to Elixir/Phoenix and Elm.

It's super easy to set up on a free Heroku instance.

Keeps track of what has been reviewed and links to GitHub commits for the actual review.

Also tracks comments on commits.

[Demo app on heroku](https://review-on-review.herokuapp.com/?auth_key=demo)

## History

Review was built to explore how practical it was to build applications in Elixir/Phoenix and Elm. Review is a reimplementation of [remit](https://github.com/henrik/remit), which in turn was inspired by [hubreview](https://github.com/joakimk/hubreview).

## Possible things to do

* [x] Be able to hide reviewed commits?
* [ ] Show a helpful message when settings are not filled in. Also hide "to review" stats until name exists.
* [ ] Add proper getting started docs and example install like remit has
* [ ] Attempt to fetch more info on authors when comments arrive and we don't already have their name/email.
* [ ] Find out how to handle dates in tests properly for the api tests
* [ ] Use shasum checking for downloads in CI
* [ ] Figure out how to test the auth\_key check in UserSocket
* [ ] Possibly make phantomjs part of the phoenix.server in dev
* [ ] Cache the last build step
* [ ] Maybe: Extract a mix package for `render_elm` and maybe a npm for the ujs, or remove both

### Make the tools better

* [ ] render\_elm is a bit problematic as it does not happen at js-time so local storage or cookies can't be loaded
* [ ] follow up the [elm-brunch discussion](https://github.com/madsflensted/elm-brunch/pull/14) on what changes to make
* [ ] Look into using [node-elm-compiler](https://github.com/rtfeldman/node-elm-compiler) in elm-brunch
* [ ] Figure out why prod sometimes tries to use the non-digested app.js name

### Collect info on how to work with Phoenix and Elm in one place

There is already blog posts, but haven't found anything that describes a development environment that works as well as something like react / rails. Might write one based on this.

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

If you use a editor plugin to issue a test command in a separate console, you can use `mix test_server` to do handle both that and run the phoenix.server in the same console window.

    source web/elm/paths.env
    mix test_server

Otherwise, start a phoenix.server in a separate console to get a dev server and build Elm code when it changes.

    mix phoenix.server

And run tests somewhere else.

### Important notice about build tool cache invalidation bugs

If you get a compile error that you don't think is actually an error you've likely run into a brunch build caching issue. In that case, restart `mix test_server`. This happens fairly often when editing multiple files.

If that does not work, you could try to remove `web/elm/elm-stuff/build-artifacts` and then restart `mix test_server` (I've only had to do this once).

### Installing an elm package or running other elm tools

    cd web/elm
    source paths.env
    elm package install name

### Troubleshooting

If you have problems with the dependencies, elixir, javascript or elm, try running `script/clean` and then `script/bootstrap` to reinstall all of it.

#### Remove commits from an unwanted repo

    heroku pg:psql -c "DELETE FROM commits WHERE id IN (SELECT id FROM commits WHERE json_payload::jsonb->'repository'->>'full_name' LIKE '%<name of the repo you want to remove commits from>%');" --app <your app name>

### Commands used to deploy to heroku

    heroku apps:create review --region eu
    heroku buildpacks:set https://github.com/gjaldon/phoenix-static-buildpack
    heroku buildpacks:add --index 1 https://github.com/HashNuke/heroku-buildpack-elixir
    heroku config:set SECRET_KEY_BASE=$(elixir -e "IO.puts :crypto.strong_rand_bytes(64) |> Base.encode64")
    heroku config:set AUTH_KEY=$(elixir -e "IO.puts Regex.replace(~r/[^a-zA-Z0-9]/, (:crypto.strong_rand_bytes(64) |> Base.encode64), \"\")")
    heroku labs:enable runtime-dyno-metadata
    git push heroku

#### Setting up Heroku Scheduler to remove old commits and comments

So we can use a small DB plan.

* Add the Heroku Scheduler add-on
* Schedule a task like: `psql $DATABASE_URL -c "DELETE FROM commits WHERE created_at < now() - INTERVAL '100 days'; DELETE FROM comments WHERE created_at < now() - INTERVAL '100 days';"`

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
