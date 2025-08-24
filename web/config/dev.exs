import Config

config :heatwave, Heatwave.Repo,
  database: Path.expand("../heatwave_dev.db", __DIR__),
  pool_size: 5,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

config :heatwave, HeatwaveWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: String.to_integer(System.get_env("PORT") || "4000")],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "yhD4OcstojUSWtU91mnlPPis0CORl3NJIlwSoG7oURd0CUOhCaNYl0hGj2Bo+GR7",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:heatwave, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:heatwave, ~w(--watch)]}
  ]

config :heatwave, HeatwaveWeb.Endpoint,
  live_reload: [
    web_console_logger: true,
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/heatwave_web/(?:controllers|live|components|router)/?.*\.(ex|heex)$"
    ]
  ]

config :heatwave, dev_routes: true
config :logger, :default_formatter, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  debug_heex_annotations: true,
  debug_attributes: true,
  enable_expensive_runtime_checks: true
