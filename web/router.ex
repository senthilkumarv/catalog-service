defmodule LoboCatalogService.Router do
  use LoboCatalogService.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :soap do
    plug :accepts, ["xml"]
  end

  scope "/sonos", LoboCatalogService do
    pipe_through :soap
    get "/", SonosController, :wsdl
    post "/", SonosController, :index
  end

  scope "/api", LoboCatalogService do
    pipe_through :api
    get "/catalog", CatalogController, :index
  end

  scope "/muxicParse", LoboCatalogService do
    pipe_through :api
    post "/classes/SoundCloudIDs", ParseController, :sound_cloud
    post "/events/AppOpened", ParseController, :app_opened
    post "/classes/Genres", ParseController, :generes
    get "/classes/Genres", ParseController, :generes
    get "/config", ParseController, :config
    post "/classes/_Installation", ParseController, :add_device
  end

  scope "/parse", LoboCatalogService do
    pipe_through :api
    post "/classes/_Installation", ParseController, :add_lobo_device
  end
end

defmodule LoboCatalogService.StaticRouter do
  use Phoenix.Router, port: 4000,
    static: [mount: "/static", priv_dir: "sonos"]
end
