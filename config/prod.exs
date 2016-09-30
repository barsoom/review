use Mix.Config

config :review, Review.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "example.com", port: 80],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: {:system, "SECRET_KEY_BASE"},
  check_origin: [ "https://#{System.get_env("HEROKU_APP_NAME")}.herokuapp.com" ]

# Do not print debug messages in production
config :logger, level: :info

config :review, Review.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 5

config :review,
  auth_key: System.get_env("AUTH_KEY"),
  webhook_secret: System.get_env("WEBHOOK_SECRET")
