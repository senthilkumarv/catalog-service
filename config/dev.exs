use Mix.Config

config :lobo_catalog_service, LoboCatalogService.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false

config :lobo_catalog_service, LoboCatalogService.Endpoint,
  live_reload: [
    patterns: [
      ~r{web/controllers/.*(ex)$},
      ~r{web/helpers/.*(ex)$},
      ~r{web/views/.*(ex)$},
      ~r{web/utilities/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

config :logger, :console, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
