defmodule LoboCatalogService.ApiClient do
  require Logger

  @scheme "http"
  @host "djloboapp.com"
  @base_url "/cms/index.php/api/"
  @key "/key/dfadfa8yfasaefacerewr4rcrx4wte5t54t"

  defp urlFor(resource) do
    "#{@scheme}://#{@host}#{@base_url}#{resource}#{@key}"
  end

  def fetch(url) do
    Logger.info "Requesting #{url}"
    response = HTTPoison.get(URI.encode(url))
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body |> Poison.decode!}
      {:ok, %HTTPoison.Response{body: body}} ->
        {:error, %{message: Poison.decode!(body)["error"]}}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %{message: reason}}
    end
  end

  def fetchResponse(resource) do
    fetch(urlFor(resource))
  end

  def fetch_duration(songFileName) do
    case fetch("http://54.210.116.209/duration/#{songFileName}") do
      {:ok, response} ->
        response["duration"]
      {:error, _error} ->
        Logger.error "Error fetching duration"
        0
    end
  end

  def add_device(info, appId) do
    IO.inspect(info)
    is_ios = info[:deviceType] == "ios"
    device_type = if (is_ios) do 0 else 1 end
    device_model = if (is_ios) do "iPhone 8,2" else "Nexus 5" end
    HTTPoison.post("http://onesignal.com/api/v1/players", EEx.eval_file("priv/parse/add_device.eex", [
          "app_id": appId,
          "identifier": info[:deviceToken],
          "language": "en",
          "timezone": -28800,
          "game_version": info[:appVersion],
          "device_os": "10.2",
          "device_type": device_type,
          "device_model": device_model
          ]))
  end
end

