defmodule Heatwave.Ingest do
  alias Heatwave.Repo
  alias Heatwave.Temperature

  def create_temperature(attrs \\ %{}) when is_map(attrs) do
    %Temperature{}
    |> Temperature.changeset(attrs)
    |> Repo.insert()
  end

  def create_temperature(sensor, value) when is_binary(sensor) and is_float(value) do
    create_temperature(%{sensor: sensor, value: value})
  end
end
