defmodule LoboCatalogService.Sonos.MediaURI do
  require EEx
  alias LoboCatalogService.{ Catalog }

  def fetch_media_uri(categoryId, songId, catalog) do
    song = Catalog.fetch_song(catalog, categoryId, songId)
    EEx.eval_file("priv/sonos/media_uri.eex", [mediaUri: "#{song[:songUrl]}"])
  end
end
