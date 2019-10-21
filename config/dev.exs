use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :review, ReviewWeb.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  check_origin: false,
  watchers: [
    node: [
      "assets/node_modules/brunch/bin/brunch",
      "watch",
      "--stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# Watch static and templates for browser reloading.
config :review, ReviewWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{lib/review_web/views/.*(ex)$},
      ~r{lib/review_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
if System.get_env("DEVBOX") do
  config :review, Review.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: "postgres",
    password: "dev",
    database: "review_dev",
    hostname: "localhost",
    port: System.cmd("service_port", ["postgres"]) |> elem(0) |> String.strip(),
    pool_size: 10
else
  config :review, Review.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: System.get_env("USER"),
    password: "",
    database: "review_dev",
    hostname: "localhost",
    pool_size: 10
end

# Skip db logging in dev, except when doing db imports since
# disabling logging breaks that for some unknown reason.
unless System.get_env("ENABLE_DB_LOGGING") do
  config :review, Review.Repo, log: false
end

# no keys needed in dev
config :review,
  auth_key: nil,
  webhook_secret: nil,
  api_secret: nil
