defmodule HeatwaveWeb.Plugs.SensorKey do
  @moduledoc "Authorize X-API-KEY for sensor access."
  import Plug.Conn
  alias Heatwave.{Repo, Sensor}

  def init(opts), do: opts

  def call(conn, _opts) do
    key = get_req_header(conn, "x-api-key") |> List.first()

    case key do
      nil ->
        conn
        |> send_resp(400, "Provide X-API-KEY")
        |> halt()

      key ->
        case Repo.get_by(Sensor, key: key) do
          %Sensor{sensor: sensor} ->
            assign(conn, :sensor, sensor)

          nil ->
            conn
            |> send_resp(403, "Forbidden")
            |> halt()
        end
    end
  end
end
