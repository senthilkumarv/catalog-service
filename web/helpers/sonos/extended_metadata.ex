defmodule LoboCatalogService.Sonos.ExtendedMetadata do
  alias LoboCatalogService.{ Catalog, ApiClient }

  def metadata(["onair"], _) do
    File.read!("priv/sonos/on_air_extended_metadata.xml")
  end

  def metadata(["category", category_id], catalog) do
    category = Catalog.fetch_category(catalog, String.to_integer(category_id))
    EEx.eval_file("priv/sonos/category_extended_metadata.eex", [
          category: category
        ])
  end

  def metadata([category_id, song_id], catalog) do
    category = Catalog.fetch_category(catalog, String.to_integer(category_id))
    IO.inspect(category)
    song = Catalog.fetch_song(catalog, String.to_integer(category_id), String.to_integer(song_id))
    songFileName = Path.basename(song[:songUrl])
    EEx.eval_file("priv/sonos/extended_metadata.eex", [
          category: category,
          song: song,
          duration: Cachex.get!(:catalog, songFileName, fallback: &ApiClient.fetch_duration/1)
        ])
  end
end
