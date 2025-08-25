defmodule Heatwave.Repo.Migrations.CreateSensors do
  use Ecto.Migration

  def change do
    create table(:sensors) do
      add :sensor, :string, null: false
      add :key, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:sensors, [:key])
  end
end
