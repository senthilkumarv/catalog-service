defmodule LoboCatalogService.Endpoint do
  use Phoenix.Endpoint, otp_app: :lobo_catalog_service

  plug Plug.RequestId
  plug Plug.Logger

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.LiveReloader
  end

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json, :soap],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head


  plug Plug.Static,
    at: "/static", from: :lobo_catalog_service,
    only: ~w(strings.xml presentationmap.xml)

  plug Plug.Static,
    at: "/", from: :lobo_catalog_service,
    only: ~w(css images js favicon.ico robots.txt)

  plug Plug.Session,
    store: :cookie,
    key: "_lobo_catalog_service_key",
    signing_salt: "//R+wBep"

  plug LoboCatalogService.Router
end
