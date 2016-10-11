# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :review, Review.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "GYJj/FPmO6UO6bO3xF7UB47lwGnS2Vgdc+yjPHOH4YOR+00hsusLtXrtSCr4eac5",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Review.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :review,
  max_records: 300,
  ecto_repos: [Review.Repo]

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :honeybadger, :environment_name, Mix.env

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
