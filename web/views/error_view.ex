defmodule LoboCatalogService.ErrorView do
  def template_not_found(_template, _assigns) do
    %{message: "Cannot fulfill request"}
  end
end
