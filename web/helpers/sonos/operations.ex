defmodule LoboCatalogService.Sonos.Operations do
  alias LoboCatalogService.Sonos.{ Metadata }
  require EEx
  require Logger

  last_update = DateTime.to_unix(DateTime.utc_now())

  def invoke({:getMetadata, _, id, index, count, recursive}) do
    Logger.debug "Get Metadata #{id} #{index} #{count} #{recursive}"
    Metadata.fetch_metadata({String.split(List.to_string(id), ":"), index, count})
  end

  def invoke({:getLastUpdate, _}) do
    Logger.debug "Get Last Update"
    {:ok, EEx.eval_file("priv/sonos/last_update.eex", [last_update: @last_update])}
  end

  def invoke({:getMediaMetadata, _, id}) do
    Logger.debug "Get media metadata #{id}"
    {:ok, %{:lastUpdate => "#{id}"}}
  end

  def invoke({:getMediaURI, _, id, action, seconds_since_explicit, device_session_token}) do
    Logger.debug "Get media URI #{id} #{action} #{seconds_since_explicit} #{device_session_token}"
    {:ok, %{:lastUpdate => "1234"}}
  end

  def invoke({:getExtendedMetadata, _, id}) do
    Logger.debug "Get extended metadata #{id}"
    {:ok, %{:lastUpdate => "1234"}}
  end

  def invoke(_) do
    {:error, %{message: "No matching operations"}}
  end

end
