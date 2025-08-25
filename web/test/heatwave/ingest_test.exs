defmodule Heatwave.IngestTest do
  use Heatwave.DataCase, async: true

  alias Heatwave.Ingest

  test "create_temperature/1 inserts a valid temperature" do
    attrs = %{sensor: "sensor1", value: 75.4}

    assert {:ok, t} = Ingest.create_temperature(attrs)
    assert t.sensor == "sensor1"
    assert t.value == 75.4
  end

  test "create_temperature/1 returns error when invalid" do
    attrs = %{sensor: "sensor1"}

    assert {:error, changeset} = Ingest.create_temperature(attrs)
    assert %{value: ["can't be blank"]} = errors_on(changeset)
  end
end
