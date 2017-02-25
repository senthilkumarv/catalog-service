defmodule LoboCatalogService.Router do
  use LoboCatalogService.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :protect_from_forgery
  end

  pipeline :soap do
    plug :accepts, ["xml"]    
  end

  scope "/sonos", LoboCatalogService do
    pipe_through :soap # Use the default browser stack
    post "/", CatalogController, :sonos
  end

  scope "/", LoboCatalogService do
    pipe_through :api # Use the default browser stack

    get "/", CatalogController, :index
  end

end
