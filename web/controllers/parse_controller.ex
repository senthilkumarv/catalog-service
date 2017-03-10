defmodule LoboCatalogService.ParseController do
  use LoboCatalogService.Web, :controller
  alias LoboCatalogService.{ApiClient}

  defp read_file_and_respond(conn, file_name) do
    conn
    |> put_resp_content_type("text/json; charset=UTF-8")
    |> send_resp(200, File.read!("priv/parse/#{file_name}"))
  end

  def sound_cloud(conn, _params) do
    read_file_and_respond(conn, "SoundCloudIDs.json")
  end

  def app_opened(conn, _params) do
    conn
    |> put_resp_content_type("text/json; charset=UTF-8")
    |> send_resp(200, "{}")
  end

  def generes(conn, _params) do
    read_file_and_respond(conn, "Generes.json")
  end

  def config(conn, _params) do
    read_file_and_respond(conn, "Parse_Config.json")
  end

  def add_device(conn, params) do
    ApiClient.add_device(params, "621c7547-612e-477f-be97-aa21b4c56fda")
    config(conn, params)
  end

  def add_lobo_device(conn, params) do
    ApiClient.add_device(params, "15442cae-bb1b-48ea-9b2f-d48e254d39bf")
    config(conn, params)
  end
end
