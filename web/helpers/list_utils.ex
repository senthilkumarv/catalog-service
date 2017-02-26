defmodule LoboCatalogService.ListUtils do
  def take_from_index(list, start_index, count) do
    list
    |> Enum.with_index
    |> Enum.filter(fn({_item, index}) -> index >= start_index end)
    |> Enum.take(count)
    |> Enum.map(fn({item, _index}) -> item end)
  end
end
