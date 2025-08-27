defmodule Heatwave.Clock do
  @moduledoc "Tick every second in sync with wall-clock time."
  use GenServer

  @spec start_link(pid(), pos_integer(), term()) :: GenServer.on_start()
  def start_link(target_pid, interval \\ 1_000, message \\ :tick) do
    GenServer.start_link(__MODULE__, {target_pid, interval, message})
  end

  @impl true
  def init({target, interval, message}) do
    schedule(interval)
    {:ok, %{target: target, interval: interval, message: message}}
  end

  @impl true
  def handle_info(:tick, %{target: target, message: message, interval: interval} = state) do
    send(target, message)
    schedule(interval)
    {:noreply, state}
  end

  defp schedule(interval) do
    now = System.system_time(:millisecond)
    delay = interval - rem(now, interval)
    Process.send_after(self(), :tick, delay)
  end
end
