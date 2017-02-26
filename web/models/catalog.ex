defmodule LoboCatalogService.Catalog do
  alias LoboCatalogService.{ Categories, Songs }
  require Logger

  def fetchCatalog() do
    case Categories.fetchAll() do
      {:ok, categories} ->
        songs = categories |> Enum.map(fn(cat) -> cat[:categoryId] end) |> Enum.map(&Songs.fetchSongsFor/1)
        { :ok, %{ categories: categories, songs: Enum.concat(songs) } }
      {:error, error} ->
        Logger.error "Error fetching categories"
        { :error, error }
    end
  end
end
