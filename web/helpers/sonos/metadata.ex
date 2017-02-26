defmodule LoboCatalogService.Sonos.Metadata do
  alias LoboCatalogService.{ ListUtils, Categories, Songs }
  require EEx
  require Logger

  def fetch_metadata({["root"], index, count}) do
    Logger.debug "Fetching root #{index} #{count}"
    case Categories.fetchAll() do
      {:ok, categories} ->
        result = EEx.eval_file "priv/sonos/root_metadata.eex", [
        categories: categories,
        index: index,
        count: Enum.count(categories) + 1]
        {:ok, result}
      _ ->
        {:error, %{:message => "Failed to fetch categories"}}
    end
  end

  def fetch_metadata({["category", categoryId], index, count}) do
    Logger.debug "Fetching media #{categoryId} #{index} #{count}"
    songs = Songs.fetchSongsFor(categoryId)
    result = EEx.eval_file "priv/sonos/category_metadata.eex", [
      songs: ListUtils.take_from_index(songs, index, count),
      index: index,
      total: Enum.count(songs)]
    {:ok, result}
  end

  def fetch_metadata(_) do
    {:error, %{:message => "Bad Request Data"}}
  end
end
