defmodule LoboCatalogService.Catalog do
  alias LoboCatalogService.{ Categories, Songs }
  require Logger


  defp fetch_from_catalog() do
    case Categories.fetchAll() do
      {:ok, categories} ->
        songs = categories |> Enum.map(fn(cat) -> cat[:categoryId] end) |> Enum.map(&Songs.fetchSongsFor/1)
        { :ok, %{ categories: categories, songs: Enum.concat(songs), last_update: DateTime.to_unix(DateTime.utc_now())} }
      {:error, error} ->
        Logger.error "Error fetching categories"
        { :error, error }
    end
  end

  def build_catalog() do
    case fetch_from_catalog() do
      {:ok, catalog} ->
        Cachex.set(:catalog, "catalog", catalog, [ ttl: :timer.minutes(60) ])
        Cachex.set(:catalog, "last_update", catalog[:last_update], [ttl: :timer.minutes(60)])
        {:ok, catalog}
      {:error, message} ->
        {:error, %{message: message}}
    end
  end

  def fetch_catalog() do
    case Cachex.get(:catalog, "catalog") do
      {:ok, value} ->
        {:ok, value}
      {:missing, _} ->
        build_catalog()
    end
  end

  def fetch_categories(catalog) do
    catalog[:categories]
  end

  def fetch_songs_with_category(catalog, categoryId) do
    category = fetch_category(catalog, categoryId)
    songs = fetch_songs(catalog, categoryId)
    %{ category: category, songs: songs }
  end

  def fetch_song(catalog, categoryId, songId) do
    Enum.find(catalog[:songs], fn(song) -> song[:songId] == songId and song[:categoryId] == categoryId end)
  end

  def fetch_songs(catalog, categoryId) do
    Enum.filter(catalog[:songs], fn(song) -> song[:categoryId] == categoryId end)
  end

  def fetch_category(catalog, categoryId) do
    Enum.find(catalog[:categories], fn(category) -> category[:categoryId] == categoryId end)
  end

end
