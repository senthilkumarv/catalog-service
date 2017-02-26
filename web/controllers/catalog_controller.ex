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

  def sonos(conn, params) do
    {:ok, body, conn} = Plug.Conn.read_body(conn, length: 1_000_000)
    Logger.info body
    conn
    |> json(params)
  end
end
