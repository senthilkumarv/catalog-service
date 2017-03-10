defmodule LoboCatalogService.Songs do
  require Logger
  alias LoboCatalogService.{ ApiClient }

  defp transform(song) do
    %{
      songId: String.to_integer(song["id_song"]),
      songTitle: Plug.HTML.html_escape(song["title"]),
      categoryId: String.to_integer(song["id_cat"]),
      songUrl: song["song_url"],
      artistId: String.to_integer(song["id_artist"]),
      featured: String.to_integer(song["featured"]) == 1
    }
  end

  def fetchSongsFor(categoryId) do
    case ApiClient.fetchResponse("music/songs/id_cat/#{categoryId}") do
      {:ok, response} ->
        Enum.map(response["Songs"], &transform/1)
      {:error, _} ->
        Logger.error "Error fetching songs from server"
        []
    end
  end

end
