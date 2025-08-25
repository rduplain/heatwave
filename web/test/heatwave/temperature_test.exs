defmodule Heatwave.TemperatureTest do
  use Heatwave.DataCase, async: true

  alias Heatwave.Temperature

  test "allows values at boundaries" do
    low = Temperature.changeset(%Temperature{}, %{sensor: "s1", value: 32.0})
    assert low.valid?

    high = Temperature.changeset(%Temperature{}, %{sensor: "s1", value: 120.0})
    assert high.valid?
  end

  test "rejects values below minimum" do
    cs = Temperature.changeset(%Temperature{}, %{sensor: "s1", value: 31.9})
    assert %{value: [msg]} = errors_on(cs)
    assert msg =~ "greater than or equal to 32"
  end

  test "rejects values above maximum" do
    cs = Temperature.changeset(%Temperature{}, %{sensor: "s1", value: 120.1})
    assert %{value: [msg]} = errors_on(cs)
    assert msg =~ "less than or equal to 120"
  end
end
