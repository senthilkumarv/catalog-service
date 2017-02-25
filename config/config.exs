# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :lobo_catalog_service,
  ecto_repos: [LoboCatalogService.Repo]

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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
