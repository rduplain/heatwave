defmodule HeatwaveWeb.ValueController do
  use HeatwaveWeb, :controller

  def create(%Plug.Conn{assigns: %{sensor: sensor}} = conn, _params) do
    with {:ok, body, _conn} <- Plug.Conn.read_body(conn),
         {:ok, value} <- parse_float(String.trim(body)),
         {:ok, _t} <- Heatwave.Ingest.create_temperature(sensor, value) do
      send_resp(conn, 204, "")
    else
      {:more, _partial, _conn} ->
        send_resp(conn, 413, "Content Too Large")

      {:error, :invalid_float} ->
        send_resp(conn, 400, "Bad Request. Provide a numeric value.")

      {:error, _} ->
        send_resp(conn, 400, "Bad Request")
    end
  end

  defp parse_float(s) do
    case Float.parse(s) do
      {f, ""} -> {:ok, f}
      _ -> {:error, :invalid_float}
    end
  end
end
