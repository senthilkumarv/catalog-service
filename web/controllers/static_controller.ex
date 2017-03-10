defmodule LoboCatalogService.StaticController do
  use LoboCatalogService.Web, :controller

  defp read_file_and_respond(conn, file_name) do
    conn
    |> put_resp_content_type("text/xml; charset=UTF-8")
    |> send_resp(200, File.read!("priv/sonos/#{file_name}"))
  end

  def presentation_map(conn, _) do
    read_file_and_respond(conn, "presentationmap.xml")
  end

  def strings(conn, _) do
    read_file_and_respond(conn, "strings.xml")
  end
end
