defmodule Heatwave.Repo.Migrations.CreateSensors do
  use Ecto.Migration

  def change do
    create table(:sensors) do
      add :sensor, :string
      add :key, :string

      timestamps(type: :utc_datetime)
    end
  end
end
