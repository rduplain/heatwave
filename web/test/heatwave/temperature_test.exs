defmodule Heatwave.TemperatureTest do
  use Heatwave.DataCase, async: true

  alias Heatwave.Temperature

  test "changeset/2 validates min and max values" do
    low = Temperature.changeset(%Temperature{}, %{sensor: "test", value: 32.0})
    assert low.valid?

    high = Temperature.changeset(%Temperature{}, %{sensor: "test", value: 120.0})
    assert high.valid?
  end

  test "changeset/2 invalidates low values" do
    changeset = Temperature.changeset(%Temperature{}, %{sensor: "test", value: 31.9})
    assert %{value: [msg]} = errors_on(changeset)
    assert msg =~ "must be greater"
  end

  test "changeset/2 invalidates high values" do
    changeset = Temperature.changeset(%Temperature{}, %{sensor: "test", value: 120.1})
    assert %{value: [msg]} = errors_on(changeset)
    assert msg =~ "must be less"
  end
end
