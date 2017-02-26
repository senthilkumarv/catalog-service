defmodule LoboCatalogService.ApiClient do
  require Logger

  @scheme "http"
  @host "djloboapp.com"
  @base_url "/cms/index.php/api/"
  @key "/key/dfadfa8yfasaefacerewr4rcrx4wte5t54t"

  defp urlFor(resource) do
    "#{@scheme}://#{@host}#{@base_url}#{resource}#{@key}"
  end

  def fetchResponse(resource) do
    url = urlFor(resource)
    Logger.info "Requesting #{url}"
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
end

