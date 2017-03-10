defmodule LoboCatalogService do
  use Application
  alias LoboCatalogService.{CacheManager}

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Cachex, [:catalog]),
      supervisor(LoboCatalogService.Endpoint, [])
    ]

    opts = [strategy: :one_for_one, name: LoboCatalogService.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    LoboCatalogService.Endpoint.config_change(changed, removed)
    :ok
  end
end
