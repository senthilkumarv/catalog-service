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


  plug Plug.Session,
    store: :cookie,
    key: "_lobo_catalog_service_key",
    signing_salt: "//R+wBep"

  plug LoboCatalogService.Router
end
