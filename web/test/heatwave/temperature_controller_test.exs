defmodule Heatwave.TemperatureControllerTest do
  use Heatwave.DataCase

  alias Heatwave.TemperatureController

  describe "temperatures" do
    alias Heatwave.TemperatureController.Temperature

    import Heatwave.TemperatureControllerFixtures

    @invalid_attrs %{value: nil, sensor: nil}

    test "list_temperatures/0 returns all temperatures" do
      temperature = temperature_fixture()
      assert TemperatureController.list_temperatures() == [temperature]
    end

    test "get_temperature!/1 returns the temperature with given id" do
      temperature = temperature_fixture()
      assert TemperatureController.get_temperature!(temperature.id) == temperature
    end

    test "create_temperature/1 with valid data creates a temperature" do
      valid_attrs = %{value: 120.5, sensor: "some sensor"}

      assert {:ok, %Temperature{} = temperature} =
               TemperatureController.create_temperature(valid_attrs)

      assert temperature.value == 120.5
      assert temperature.sensor == "some sensor"
    end

    test "create_temperature/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               TemperatureController.create_temperature(@invalid_attrs)
    end

    test "update_temperature/2 with valid data updates the temperature" do
      temperature = temperature_fixture()
      update_attrs = %{value: 456.7, sensor: "some updated sensor"}

      assert {:ok, %Temperature{} = temperature} =
               TemperatureController.update_temperature(temperature, update_attrs)

      assert temperature.value == 456.7
      assert temperature.sensor == "some updated sensor"
    end

    test "update_temperature/2 with invalid data returns error changeset" do
      temperature = temperature_fixture()

      assert {:error, %Ecto.Changeset{}} =
               TemperatureController.update_temperature(temperature, @invalid_attrs)

      assert temperature == TemperatureController.get_temperature!(temperature.id)
    end

    test "delete_temperature/1 deletes the temperature" do
      temperature = temperature_fixture()
      assert {:ok, %Temperature{}} = TemperatureController.delete_temperature(temperature)

      assert_raise Ecto.NoResultsError, fn ->
        TemperatureController.get_temperature!(temperature.id)
      end
    end

    test "change_temperature/1 returns a temperature changeset" do
      temperature = temperature_fixture()
      assert %Ecto.Changeset{} = TemperatureController.change_temperature(temperature)
    end
  end
end
