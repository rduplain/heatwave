defmodule Heatwave.Temperature do
  @moduledoc "Temperature (degrees F) from a sensor at a given time."
  use Ecto.Schema
  import Ecto.Changeset

  @min 32
  @max 120

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
    |> validate_number(:value, greater_than_or_equal_to: @min)
    |> validate_number(:value, less_than_or_equal_to: @max)
  end

  def min, do: @min
  def max, do: @max
  def valid?(temperature), do: temperature >= @min and temperature <= @max

  def min_label, do: "#{@min}°F"
  def max_label, do: "#{@max}°F"
  def invalid_msg, do: "Provide temperature between #{min_label()} and #{max_label()}."
end
