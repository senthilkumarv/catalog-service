defmodule LoboCatalogService.Sonos.MediaURI do
  require EEx
  alias LoboCatalogService.{ Catalog }

  def fetch_media_uri([categoryId, songId], catalog) do
    song = Catalog.fetch_song(catalog, String.to_integer(categoryId), String.to_integer(songId))
    EEx.eval_file("priv/sonos/media_uri.eex", [mediaUri: URI.encode("#{song[:songUrl]}")])
  end

  def fetch_media_uri(["onair"], _catalog) do
    EEx.eval_file("priv/sonos/media_uri.eex", [mediaUri: "http://173.239.10.39:8555/live"])
  end
end
