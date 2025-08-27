defmodule Heatwave.Temperature do
  @moduledoc "Temperature (degrees F) from a sensor at a given time."
  use Ecto.Schema
  import Ecto.Changeset

  schema "temperatures" do
    field :sensor, :string
    field :value, :float

    timestamps(type: :utc_datetime)
  end

  def topic, do: __schema__(:source)

  def changeset(temperature, attrs) do
    temperature
    |> cast(attrs, [:sensor, :value])
    |> validate_required([:sensor, :value])
    |> validate_number(:value, greater_than_or_equal_to: 32)
    |> validate_number(:value, less_than_or_equal_to: 120)
  end
end
