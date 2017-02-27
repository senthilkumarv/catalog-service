defmodule LoboCatalogService.CatalogController do
  require Logger
  use LoboCatalogService.Web, :controller
  alias LoboCatalogService.{Catalog}

  def index(conn, _params) do
    case Catalog.fetch_catalog()  do
      {:ok, response} ->
        conn |> json(response)
      {:error, response} ->
        conn |> put_status(400) |> json(response)
    end
  end
end

