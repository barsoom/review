use Mix.Config

config :review, Review.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "example.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
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
  webhook_secret: System.get_env("WEBHOOK_SECRET"),
  api_secret: System.get_env("API_SECRET"),
  max_records: String.to_integer(System.get_env("MAX_RECORDS") || "500")

# Disabling tzdata autoupdate since I don't think using old data would affect this app
# and it frequently raises errors. https://github.com/bitwalker/timex/issues/396
config :tzdata, :autoupdate, :disabled
