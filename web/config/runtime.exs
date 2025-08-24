# config/runtime.exs executed for all environments, including during releases.
import Config

# Using `mix release`:
#
#     PHX_SERVER=true bin/heatwave start
#
# Alternatively, use `mix phx.gen.release` to generate a `bin/server`.
if System.get_env("PHX_SERVER") do
  config :heatwave, HeatwaveWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_path =
    System.get_env("DATABASE_PATH") ||
      raise """
      environment variable DATABASE_PATH is missing.
      For example: /etc/heatwave/heatwave.db
      """

  config :heatwave, Heatwave.Repo,
    database: database_path,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "5")

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      Generate by calling `mix phx.gen.secret`.
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :heatwave, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :heatwave, HeatwaveWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      # https://hexdocs.pm/bandit/Bandit.html#t:options/0
      ip: {0, 0, 0, 0, 0, 0, 0, 1},
      port: port
    ],
    secret_key_base: secret_key_base
end
