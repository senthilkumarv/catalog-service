defmodule LoboCatalogService.CatalogController do
  use LoboCatalogService.Web, :controller

  def mapCategories(categories) do
    Enum.map(categories["Categories"], fn(category) -> %{
                                         categoryId: String.to_integer(category["id_cat"]),
                                         categoryTitle: category["title"],
                                         order: String.to_integer(category["cat_order"]),
                                         totalSongs: String.to_integer(category["total_songs"])
                                     } end)
  end

  def fetchSongsFor(category) do
    url = "http://djloboapp.com/cms/index.php/api/music/songs/id_cat/#{category[:categoryId]}/key/dfadfa8yfasaefacerewr4rcrx4wte5t54t"
    case fetchResponse(url) do
      {:ok, response} ->
        Enum.map(response["Songs"], fn(song) -> %{
                                                songId: String.to_integer(song["id_song"]),
                                                songTitle: song["title"],
                                                categoryId: String.to_integer(song["id_cat"]),
                                                songUrl: song["song_url"],
                                                artistId: String.to_integer(song["id_artist"]),
                                                featured: String.to_integer(song["featured"]) == 1
                                            } end)
      {:error, _} ->
        IO.puts("Error fetching songs")
        []
    end
  end

  def fetchResponse(url) do
    response = HTTPoison.get(url)
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body |> Poison.decode!}
      {:ok, %HTTPoison.Response{body: body}} ->
        {:error, %{message: Poison.decode!(body)["error"]}}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %{message: reason}}
    end
  end

  def index(conn, _params) do
    response = fetchResponse("http://djloboapp.com/cms/index.php/api/categories/all/key/dfadfa8yfasaefacerewr4rcrx4wte5t54t")
    case response  do
      {:ok, response} ->
        categories = mapCategories(response)
        songs = Enum.map(categories, &fetchSongsFor/1)
        conn
        |> json(%{
              categories: mapCategories(response),
              songs: Enum.concat(songs)
                })
      {:error, response} ->
        conn
        |> put_status(400)
        |> json(response)
    end
  end

  def sonos(conn, params) do
    {:ok, body, conn} = Plug.Conn.read_body(conn, length: 1_000_000)
    IO.puts(body)
    conn
    |> json(params)
  end
end
