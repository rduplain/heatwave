defmodule Heatwave.TemperatureControllerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Heatwave.TemperatureController` context.
  """

  @doc """
  Generate a temperature.
  """
  def temperature_fixture(attrs \\ %{}) do
    {:ok, temperature} =
      attrs
      |> Enum.into(%{
        sensor: "some sensor",
        value: 120.5
      })
      |> Heatwave.TemperatureController.create_temperature()

    temperature
  end
end
