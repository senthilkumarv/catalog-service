defmodule LoboCatalogService.Sonos.Operations do
  alias LoboCatalogService.Sonos.{ Metadata, MediaURI, ExtendedMetadata }
  require EEx
  require Logger

  def invoke({:getMetadata, _, id, index, count, recursive}, catalog) do
    Logger.debug "Get Metadata #{id} #{index} #{count} #{recursive}"
    Metadata.fetch_metadata({
        String.split(List.to_string(id), ":"),
        index,
        count
      }, catalog)
  end

  def invoke({:getLastUpdate, _}, catalog) do
    Logger.debug "Get Last Update"
    EEx.eval_file("priv/sonos/last_update.eex", [
          last_update: catalog[:last_update]])
  end

  def invoke({:getMediaMetadata, _, id}, catalog) do
    Logger.debug "Get media metadata #{id}"
    Metadata.fetch_media_metadata(
      String.split(List.to_string(id), ":"),
      catalog)
  end

  def invoke({:getMediaURI, _, id, action, seconds_since_explicit, device_session_token}, catalog) do
    Logger.debug "Get media URI #{id} #{action} #{seconds_since_explicit} #{device_session_token}"
    MediaURI.fetch_media_uri(
      String.split(List.to_string(id), ":"),
      catalog)
  end

  def invoke({:getExtendedMetadata, _, id}, catalog) do
    Logger.debug "Get extended metadata #{id}"
    ExtendedMetadata.metadata(String.split(List.to_string(id), ":"), catalog)
  end

  def invoke(_, _catalog) do
    {:error, "No matching operations"}
  end

end
