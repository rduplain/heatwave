defmodule HeatwaveWeb.SeriesManagerTest do
  use ExUnit.Case

  alias HeatwaveWeb.SeriesManager

  test "create/2 adds a new series filled with nils" do
    manager = SeriesManager.new(3) |> SeriesManager.create("temperature")
    assert Map.has_key?(manager.data, "temperature")
    assert length(manager.data["temperature"]) == 3
    assert Enum.all?(manager.data["temperature"], &is_nil/1)
  end

  test "tick/1 shifts all series and duplicates the last value" do
    manager =
      SeriesManager.new(3)
      |> SeriesManager.create("temp")
      |> SeriesManager.update("temp", 10)

    ticked = SeriesManager.tick(manager)
    assert length(ticked.data["temp"]) == 3
    assert List.last(ticked.data["temp"]) == 10
    assert Enum.at(ticked.data["temp"], 0) == nil
    assert Enum.at(ticked.data["temp"], 1) == 10
  end

  test "tick/1 with multiple values shifts correctly" do
    manager =
      SeriesManager.new(3)
      |> SeriesManager.create("temp")
      |> SeriesManager.update("temp", 5)
      |> SeriesManager.tick()
      |> SeriesManager.update("temp", 15)
      |> SeriesManager.tick()

    assert length(manager.data["temp"]) == 3
    assert manager.data["temp"] == [5, 15, 15]
  end

  test "to_chart/1 converts manager to Chart.js format" do
    manager =
      SeriesManager.new(2)
      |> SeriesManager.create("sensor1")
      |> SeriesManager.create("sensor2")
      |> SeriesManager.update("sensor1", 100)
      |> SeriesManager.update("sensor2", 200)

    chart = SeriesManager.to_chart(manager)
    assert length(chart.labels) == 2
    assert length(chart.datasets) == 2

    sensor1_series = Enum.find(chart.datasets, &(&1.label == "sensor1"))
    sensor2_series = Enum.find(chart.datasets, &(&1.label == "sensor2"))

    assert sensor1_series.data == [nil, 100]
    assert sensor2_series.data == [nil, 200]
  end

  test "to_chart/1 with ticked data" do
    manager =
      SeriesManager.new(3)
      |> SeriesManager.create("sensor")
      |> SeriesManager.update("sensor", 20)
      |> SeriesManager.tick()
      |> SeriesManager.update("sensor", 25)

    chart = SeriesManager.to_chart(manager)
    sensor_series = Enum.find(chart.datasets, &(&1.label == "sensor"))
    assert sensor_series.data == [nil, 20, 25]
  end

  test "tick/1 with multiple series shifts correctly" do
    manager =
      SeriesManager.new(2)
      |> SeriesManager.create("sensor1")
      |> SeriesManager.create("sensor2")
      |> SeriesManager.update("sensor1", 45)
      |> SeriesManager.update("sensor2", 66)
      |> SeriesManager.tick()
      |> SeriesManager.update("sensor1", 48)

    assert manager.data["sensor1"] == [45, 48]
    assert manager.data["sensor2"] == [66, 66]

    chart = SeriesManager.to_chart(manager)
    assert length(chart.datasets) == 2
  end
end
