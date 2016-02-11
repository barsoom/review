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
      elmFolder: "web/elm"
      outputFile: "../static/vendor/compiled_elm.js"

    assetsmanager:
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
