defmodule LoboCatalogService.CatalogController do
  require Logger
  use LoboCatalogService.Web, :controller
  alias LoboCatalogService.{Categories}

  def index(conn, _params) do
    case Categories.fetchCategories()  do
      {:ok, response} ->
        conn |> json(response)
      {:error, response} ->
        conn |> put_status(400) |> json(response)
    end
  end
end

