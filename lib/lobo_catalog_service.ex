defmodule LoboCatalogService do
  use Application
  alias ExAws.Dynamo
  alias LoboCatalogService.{ Catalog }

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(LoboCatalogService.Endpoint, [])
    ]

    opts = [strategy: :one_for_one, name: LoboCatalogService.Supervisor]
    Cachex.start_link(:catalog, [default_ttl: -1])
    populate_cache_with_duration()
    Catalog.build_catalog()
    Supervisor.start_link(children, opts)
  end

  def populate_cache_with_duration() do
    Dynamo.scan("music-duration")
    |> ExAws.request!
    |> Access.get("Items")
    |> Enum.map(fn(element) -> Cachex.set!(:catalog, element["filename"]["S"], String.to_integer(element["duration"]["N"])) end)
  end

  def config_change(changed, _new, removed) do
    LoboCatalogService.Endpoint.config_change(changed, removed)
    :ok
  end
end
