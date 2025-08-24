import Config

# See `mix help test` for more information.
config :heatwave, Heatwave.Repo,
  database: Path.expand("../heatwave_test.db", __DIR__),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# Set `server` to true to run server during test.
config :heatwave, HeatwaveWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "rOnlUitKta0M1RKc8pOMRpzefliAYsQWvfYX7/mxWmsbfwyz33T4THE+Nl3WLTvx",
  server: false

config :logger, level: :warning

# Use `:runtime` for faster test compilation.
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  enable_expensive_runtime_checks: true
