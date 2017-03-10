defmodule LoboCatalogService.Categories do
  require Logger

  alias LoboCatalogService.{ApiClient}

  defp transform(category) do
    %{
      categoryId: String.to_integer(category["id_cat"]),
      categoryTitle: Plug.HTML.html_escape(category["title"]),
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

end
