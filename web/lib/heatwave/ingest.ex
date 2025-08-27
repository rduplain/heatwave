defmodule Heatwave.Ingest do
  alias Heatwave.Repo
  alias Heatwave.Temperature
  alias Phoenix.PubSub

  def create_temperature(attrs \\ %{}) when is_map(attrs) do
    case %Temperature{}
         |> Temperature.changeset(attrs)
         |> Repo.insert() do
      {:ok, temperature} -> broadcast(temperature)
      error -> error
    end
  end

  def create_temperature(sensor, value) when is_binary(sensor) and is_float(value) do
    create_temperature(%{sensor: sensor, value: value})
  end

  defp broadcast(temperature) do
    PubSub.broadcast(
      Heatwave.PubSub,
      Temperature.topic(),
      {:temperature, temperature.sensor, temperature.value}
    )

    {:ok, temperature}
  end
end
