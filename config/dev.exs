use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :lobo_catalog_service, LoboCatalogService.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false

# Watch static and templates for browser reloading.
config :lobo_catalog_service, LoboCatalogService.Endpoint,
  live_reload: [
    patterns: [
      ~r{web/controllers/.*(ex)$},
      ~r{web/helpers/.*(ex)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :lobo_catalog_service, LoboCatalogService.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "senthil",
  password: "ZsrggAr4fW8uqRVFr3",
  database: "Wings",
  hostname: "wings.cj3kxdriawxc.us-east-1.rds.amazonaws.com",
  pool_size: 10
