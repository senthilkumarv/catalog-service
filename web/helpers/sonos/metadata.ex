defmodule LoboCatalogService.Sonos.Metadata do
  alias LoboCatalogService.{ ListUtils, Catalog }
  require EEx
  require Logger

  def fetch_metadata({["root"], index, count}, catalog) do
    Logger.debug "Fetching root #{index} #{count}"
    categories = Catalog.fetch_categories(catalog)
    EEx.eval_file "priv/sonos/root_metadata.eex", [
      categories: categories,
      index: index,
      count: Enum.count(categories) + 1]
  end

  def fetch_metadata({["category", categoryId], index, count}, catalog) do
    Logger.debug "Fetching media #{categoryId} #{index} #{count}"
    result = Catalog.fetch_songs_with_category(catalog, String.to_integer(categoryId))
    songs = result[:songs]
    category = result[:category]
    EEx.eval_file "priv/sonos/category_metadata.eex", [
      songs: ListUtils.take_from_index(songs, index, count),
      index: index,
      category: category,
      total: Enum.count(songs)]
  end

  def fetch_metadata(_, catalog) do
    {:error, %{:message => "Bad Request Data"}}
  end
end
