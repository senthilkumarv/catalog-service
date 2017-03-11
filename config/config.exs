# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :lobo_catalog_service, LoboCatalogService.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "T2jyfo4oMQycIGWevcg/RGDk/DMQkNUoGjZcRP/HDsDbzRCaoAwUBxkNAboE5DBz",
  render_errors: [view: LoboCatalogService.ErrorView, format: "json"],
  pubsub: [name: LoboCatalogService.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: "us-east-1"


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
