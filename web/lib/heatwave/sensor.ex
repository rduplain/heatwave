defmodule Heatwave.Sensor do
  @moduledoc "Sensor devices connecting as clients to publish data."
  use Ecto.Schema
  import Ecto.Changeset

  schema "sensors" do
    field :sensor, :string
    field :key, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(sensor, attrs) do
    sensor
    |> cast(attrs, [:sensor, :key])
    |> validate_required([:sensor, :key])
    |> unique_constraint(:key)
  end
end
