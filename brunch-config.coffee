exports.config =
  files:
    javascripts:
      joinTo: "js/app.js"

    stylesheets:
      joinTo: "css/app.css"

    templates:
      joinTo: "js/app.js"

  conventions:
    assets: /^(web\/static\/assets)/
    ignored: [
      /\/_.*/
      /elm-stuff/
      /elm-package\.json/
      /elm\/paths\.env/
    ]

  paths:
    public: "priv/static"
    watched: [
      "web/static"
      "web/elm"
      "test/static"
    ]

  plugins:
    babel:
      ignore: [ /web\/static\/vendor/ ]

    elmBrunch:
      executablePath: "../../node_modules/elm/binwrappers"
      elmFolder: "web/elm"
      mainModules: [ "Settings.elm", "CommitList.elm", "CommentList.elm" ]
      outputFolder: "../static/vendor"
      outputFile: "compiled_elm.js"
      makeParameters: [ "--warn" ]

    assetsmanager:
      # only copy on boot to not trigger double live reloads when other files change
      minTimeSpanSeconds: 10000

      copyTo:
        "fonts": [ "web/static/vendor/css/font-awesome-4.5.0/fonts/*" ]

  modules:
    autoRequire:
      "js/app.js": [ "web/static/js/app" ]

  npm:
    enabled: true
    whitelist: [
      "phoenix"
      "phoenix_html"
    ]
