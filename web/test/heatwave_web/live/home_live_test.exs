defmodule HeatwaveWeb.HomeLiveTest do
  use HeatwaveWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias Heatwave.Sensor
  alias Heatwave.Repo

  setup do
    {:ok, sensor1} = Repo.insert(%Sensor{sensor: "temp1", key: "key1"})
    {:ok, sensor2} = Repo.insert(%Sensor{sensor: "temp2", key: "key2"})
    %{sensor1: sensor1, sensor2: sensor2}
  end

  test "GET / live view contains chart and series", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")

    assert html =~ "phx-hook=\"Chart\""
    assert html =~ "&quot;temp1&quot;"
    assert html =~ "&quot;temp2&quot;"
  end
end
