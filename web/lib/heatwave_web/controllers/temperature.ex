defmodule HeatwaveWeb.TemperatureController do
  @moduledoc "Create temperature from a plaintext float."
  use HeatwaveWeb, :controller

  alias HeatwaveWeb.Error
  alias Heatwave.Temperature
  require Logger

  def create(%Plug.Conn{assigns: %{sensor: sensor}} = conn, _params) do
    {body, conn} = read(conn)
    create_temperature(sensor, parse(String.trim(body)))
    send_resp(conn, 204, "")
  rescue
    e in Error -> Error.respond(conn, e)
  end

  defp read(conn) do
    case Plug.Conn.read_body(conn) do
      {:ok, body, conn} -> {body, conn}
      {:more, _partial, _conn} -> raise Error.too_large()
      {:error, _reason} -> raise Error.bad_request()
    end
  end

  defp parse(text) do
    case Float.parse(text) do
      {value, ""} ->
        if Temperature.valid?(value) do
          value
        else
          raise Error.bad_request(Temperature.invalid_msg())
        end

      _ ->
        raise Error.bad_request("Provide a numeric value.")
    end
  end

  defp create_temperature(sensor, value) do
    case Heatwave.Ingest.create_temperature(sensor, value) do
      {:ok, temperature} ->
        temperature

      {:error, reason} ->
        Logger.error("Failed to create temperature: #{inspect(reason)}")
        raise Error.server_error()
    end
  end
end
