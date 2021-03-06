defmodule LoboCatalogService.Mixfile do
  use Mix.Project

  def project do
    [app: :lobo_catalog_service,
     version: "0.0.1",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.

  def application do
    [mod: {LoboCatalogService, []},
     applications: [
       :phoenix,
       :phoenix_pubsub,
       :cowboy,
       :logger,
       :poison,
       :httpoison,
       :hackney,
       :erlsom,
       :configparser_ex,
       :ex_aws,
       :cachex]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.1"},
     {:phoenix_pubsub, "~> 1.0"},
     {:httpoison, "~> 0.11.1"},
     {:poison, "~> 2.2.0"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:erlsom, "~> 1.4"},
     {:cachex, "~> 2.1.0"},
     {:ex_aws, "~> 1.1"},
     {:configparser_ex, "~> 0.2.1"},
     {:hackney, "~> 1.7.1", override: true},
     {:cowboy, "~> 1.0"}]
  end

end
