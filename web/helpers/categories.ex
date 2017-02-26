defmodule LoboCatalogService.Categories do
  require Logger

  alias LoboCatalogService.{ApiClient, Songs}

  defp transform(category) do
    %{
      categoryId: String.to_integer(category["id_cat"]),
      categoryTitle: category["title"],
      order: String.to_integer(category["cat_order"]),
      totalSongs: String.to_integer(category["total_songs"])
   }
  end

  def fetchAll() do
    case ApiClient.fetchResponse("categories/all") do
      {:ok, response} ->
        categories = Enum.map(response["Categories"], &transform/1)
        { :ok, categories }
      {:error, error} ->
        Logger.error "Error fetching categories"
        { :error, error }
    end
  end

  def fetchCategories() do
    case ApiClient.fetchResponse("categories/all") do
      {:ok, response} ->
        categories = Enum.map(response["Categories"], &transform/1)
        songs = categories |> Enum.map(fn(cat) -> cat[:categoryId] end) |> Enum.map(&Songs.fetchSongsFor/1)
        { :ok, %{ categories: categories, songs: Enum.concat(songs) } }
      {:error, error} ->
        Logger.error "Error fetching categories"
        { :error, error }
    end
  end
end
