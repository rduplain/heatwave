defmodule Heatwave.Repo do
  use Ecto.Repo,
    otp_app: :heatwave,
    adapter: Ecto.Adapters.SQLite3
end
