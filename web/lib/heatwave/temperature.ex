defmodule Heatwave.Temperature do
  use Ecto.Schema
  import Ecto.Changeset

  schema "temperatures" do
    field :sensor, :string
    field :value, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(temperature, attrs) do
    temperature
    |> cast(attrs, [:sensor, :value])
    |> validate_required([:sensor, :value])
  end
end
