defmodule Heatwave.Repo do
  @moduledoc "Database handle."
  use Ecto.Repo,
    otp_app: :heatwave,
    adapter: Ecto.Adapters.SQLite3
end
