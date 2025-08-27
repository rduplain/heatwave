defmodule Mix.Tasks.Heatwave.Simulate do
  use Mix.Task
  require Logger

  @shortdoc "Simulate sensors posting temperatures via HTTP."
  @moduledoc """
  Usage:
    mix heatwave.simulate [--url http://localhost:4000] [--dt 2000] [--delta 1.5]

  Options:
    --url    Base URL of running Heatwave server, default http://localhost:4000.
    --dt     Milliseconds between temperature posts, default: 2000.
    --delta  Max +/- degrees F per tick, default: 1.5.

  Simulation reads all API keys from sensors table, runs one process per sensor.
  """

  @default %{
    url: "http://localhost:4000",
    dt: 2000,
    delta: 1.5
  }

  @temperature %{
    room: 70.0,
    initial_step: @default.delta * 2,
    min: 40.0,
    max: 90.0
  }

  @impl true
  def run(args) do
    Mix.Task.run("app.start")
    :ok = Application.ensure_started(:inets)
    :ok = Application.ensure_started(:ssl)

    {opts, _rest, invalid} =
      OptionParser.parse(args, strict: [url: :string, dt: :integer, delta: :float])

    if not Enum.empty?(invalid) do
      Mix.raise("Invalid options: #{inspect(invalid)}")
    end

    url = opts[:url] || @default.url
    dt = opts[:dt] || @default.dt
    delta = opts[:delta] || @default.delta

    keys =
      try do
        Heatwave.Repo.all(Heatwave.Sensor)
        |> Enum.map(& &1.key)
        |> case do
          [] -> Mix.raise("No sensors found. Seed with `mix setup`.")
          result -> result
        end
      rescue
        e in [Exqlite.Error, Ecto.QueryError] ->
          Mix.raise("Database error: #{inspect(e)}.\n\nRun `mix setup` to fix.")
      end

    IO.puts("Running #{length(keys)} simulators: url=#{url}, delta=±#{delta}, dt=#{dt}ms")

    for key <- keys do
      attrs = %{url: url, key: key, dt: dt, delta: delta, value: initial()}
      spawn_link(fn -> loop(attrs) end)
    end

    Process.sleep(:infinity)
  end

  @dialyzer {:no_return, loop: 1}
  defp loop(%{url: url, key: key, dt: dt, delta: delta, value: value} = attrs) do
    post(url, key, value)
    :timer.sleep(dt)
    loop(%{attrs | value: step(value, delta)})
  end

  defp post(base, key, value) do
    url = base <> "/value"
    header = [{~c"X-API-KEY", key}]

    case :httpc.request(:post, {url, header, ~c"text/plain", "#{value}"}, [], []) do
      {:ok, {{_http_version, status, _reason}, _header, body}} ->
        if status in 200..299 do
          {:ok, body}
        else
          Logger.error("POST #{url} status=#{status} body=#{inspect(body)}")
          {:error, {:status, status, body}}
        end

      {:error, reason} ->
        Logger.error("POST failed: #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp step(temperature, delta) do
    # Primitive markov generator, step ±1 times delta.
    r = (:rand.uniform() * 2.0 - 1.0) * delta
    clamp(temperature + r, @temperature.min, @temperature.max)
  end

  defp initial(), do: step(@temperature.room, @temperature.initial_step)

  defp clamp(v, min, _max) when v < min, do: min
  defp clamp(v, _min, max) when v > max, do: max
  defp clamp(v, _min, _max), do: v
end
