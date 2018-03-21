use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :review, Review.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
if System.get_env("DEVBOX") do
  config :review, Review.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: "postgres",
    password: "dev",
    database: "review_test",
    hostname: "localhost",
    port: System.cmd("service_port", ["postgres"]) |> elem(0) |> String.trim,
    pool: Ecto.Adapters.SQL.Sandbox
else
  config :review, Review.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: System.get_env("POSTGRES_USER") || System.get_env("USER"),
    password: "",
    database: "review_test",
    hostname: "localhost",
    pool: Ecto.Adapters.SQL.Sandbox
end

config :review,
  auth_key: "secret",
  webhook_secret: "webhook_secret",
  api_secret: "api_secret"

config :hound, driver: "phantomjs"
