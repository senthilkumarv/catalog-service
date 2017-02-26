defmodule LoboCatalogService.SonosController do
  require Logger
  require EEx
  use LoboCatalogService.Web, :controller
  alias LoboCatalogService.{ Categories, Songs }

  def takeFromIndex(list, start_index, count) do
    list
    |> Enum.with_index
    |> Enum.filter(fn({_item, index}) -> index >= start_index end)
    |> Enum.take(count)
    |> Enum.map(fn({item, _index}) -> item end)
  end

  def fetchMetadata(body) do
    case body do
      {["root"], index, count} ->
        Logger.debug "Fetching root #{index} #{count}"
        categories = Categories.fetchAll()
        case categories do
          {:ok, categories} ->
            EEx.eval_file "priv/sonos/root_metadata.eex", [
              categories: categories,
              index: index,
              count: Enum.count(categories) + 1]
          _ ->
            EEx.eval_file "priv/sonos/fault.eex", []
        end
      {["category", categoryId], index, count} ->
        Logger.debug "Fetching media #{categoryId} #{index} #{count}"
        songs = Songs.fetchSongsFor(categoryId)
        EEx.eval_file "priv/sonos/category_metadata.eex", [
          songs: takeFromIndex(songs, index, count),
          index: index,
          total: Enum.count(songs)]
      _ ->
        EEx.eval_file "priv/sonos/fault.eex", []
    end
  end

  def index(conn, params) do
    case params[:body] do
      {:getMetadata, _, id, index, count, recursive} ->
        Logger.debug "Get Metadata #{id} #{index} #{count} #{recursive}"
        result = fetchMetadata({String.split(List.to_string(id), ":"), index, count})
        conn
        |> put_resp_content_type("text/xml; charset=UTF-8")
        |> send_resp(200, result)
      {:getLastUpdate, _} ->
        Logger.debug "Get Last Update"
        result = EEx.eval_file "priv/sonos/last_update.eex", [last_update: "123456"]
        conn
        |> put_resp_content_type("text/xml; charset=UTF-8")
        |> send_resp(200, result)
      {:getMediaMetadata, _, id} ->
        Logger.debug "Get media metadata #{id}"
        conn |> json(%{:lastUpdate => "#{id}"})
      {:getMediaURI, _, id, action, seconds_since_explicit, device_session_token} ->
        Logger.debug "Get media URI #{id} #{action} #{seconds_since_explicit} #{device_session_token}"
        conn |> json(%{:lastUpdate => "1234"})
      {:getExtendedMetadata, _, id} ->
        Logger.debug "Get extended metadata #{id}"
        conn |> json(%{:lastUpdate => "1234"})
      _ ->
        conn
        |> put_resp_content_type("text/xml; charset=UTF-8")
        |> send_resp(200, EEx.eval_file("priv/sonos/fault.eex", []))
    end
  end
end
