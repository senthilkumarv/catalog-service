defmodule LoboCatalogService.SonosController do
  require Logger
  require EEx
  use LoboCatalogService.Web, :controller
  alias LoboCatalogService.{ Catalog }
  alias LoboCatalogService.Sonos.{ Operations }

  defp invoke(conn, body, catalog) do
    case Operations.invoke(body, catalog) do
      { :ok, response } ->
        conn
        |> put_resp_content_type("text/xml; charset=UTF-8")
        |> send_resp(200, response)
      { :error, _ } ->
        send_fault(conn)
    end
  end

  def index(conn, params) do
    case Catalog.fetch_catalog() do
      {:ok, catalog} ->
        invoke(conn, params[:body], catalog)
      {:error, _} ->
        send_fault(conn)
    end
  end

  def wsdl(conn, params) do
    case params do
      %{"wsdl" => _} ->
        conn
        |> put_resp_content_type("text/xml; charset=UTF-8")
        |> send_resp(200, File.read!("priv/sonos/Sonos.wsdl"))
      _ ->
        send_fault(conn)
    end
  end

  defp send_fault(conn) do
    conn
    |> put_resp_content_type("text/xml; charset=UTF-8")
    |> send_resp(400, File.read!("priv/sonos/fault.eex"))
  end
end
