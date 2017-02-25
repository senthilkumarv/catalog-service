use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :lobo_catalog_service, LoboCatalogService.Endpoint,
  secret_key_base: "RSptN848MUOHE4V5GLfCTSfz4nFESdXDaYvyxGrykP02hq65IWz+bN7YnSE/QuC9"

# Configure your database
config :lobo_catalog_service, LoboCatalogService.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "senthil",
  password: "ZsrggAr4fW8uqRVFr3",
  database: "Wings",
  hostname: "wings.cj3kxdriawxc.us-east-1.rds.amazonaws.com",
  pool_size: 10
