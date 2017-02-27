defmodule LoboCatalogService.Sonos.Operations do
  alias LoboCatalogService.Sonos.{ Metadata, MediaURI }
  require EEx
  require Logger

  def invoke({:getMetadata, _, id, index, count, recursive}, catalog) do
    Logger.debug "Get Metadata #{id} #{index} #{count} #{recursive}"
    {:ok, Metadata.fetch_metadata({String.split(List.to_string(id), ":"), index, count}, catalog)}
  end

  def invoke({:getLastUpdate, _}, catalog) do
    Logger.debug "Get Last Update"
    {:ok, EEx.eval_file("priv/sonos/last_update.eex", [last_update: catalog[:last_update]])}
  end

  def invoke({:getMediaMetadata, _, id}, _catalog) do
    Logger.debug "Get media metadata #{id}"
    {:ok, %{:lastUpdate => "#{id}"}}
  end

  def invoke({:getMediaURI, _, id, action, seconds_since_explicit, device_session_token}, catalog) do
    Logger.debug "Get media URI #{id} #{action} #{seconds_since_explicit} #{device_session_token}"
    [categoryId, songId] = String.split(List.to_string(id), ":")
    {:ok, MediaURI.fetch_media_uri(String.to_integer(categoryId), String.to_integer(songId), catalog)}
  end

  def invoke({:getExtendedMetadata, _, id}, _catalog) do
    Logger.debug "Get extended metadata #{id}"
    {:ok, %{:lastUpdate => "1234"}}
  end

  def invoke(_, _catalog) do
    {:error, %{message: "No matching operations"}}
  end

end
