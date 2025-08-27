defmodule HeatwaveWeb.HomeLive do
  @moduledoc "Render chart dashboard."
  use HeatwaveWeb, :live_view

  alias Heatwave.Repo
  alias Heatwave.Sensor
  alias Phoenix.PubSub
  alias HeatwaveWeb.SeriesManager
  alias Heatwave.Temperature

  @theme :dark

  @history 30
  @interval 1_000
  @ymax 120
  @ymin 32

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Heatwave.Clock.start_link(self(), @interval, :tick)

    manager =
      Enum.reduce(Repo.all(Sensor), SeriesManager.new(@history), fn record, manager ->
        SeriesManager.create(manager, record.sensor)
      end)

    if connected?(socket), do: PubSub.subscribe(Heatwave.PubSub, Temperature.topic())

    socket =
      assign(socket,
        chart: SeriesManager.to_chart(manager),
        manager: manager,
        theme: @theme,
        ymax: @ymax,
        ymin: @ymin
      )

    {:ok, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    %{manager: manager} = socket.assigns
    manager = SeriesManager.tick(manager)
    chart = SeriesManager.to_chart(manager)

    if connected?(socket), do: send(self(), {:push_chart, chart})

    {:noreply, assign(socket, chart: chart, manager: manager)}
  end

  @impl true
  def handle_info({:temperature, sensor, value}, socket) do
    %{manager: manager} = socket.assigns
    manager = SeriesManager.update(manager, sensor, value)
    chart = SeriesManager.to_chart(manager)

    if connected?(socket), do: send(self(), {:push_chart, chart})

    {:noreply, assign(socket, chart: chart, manager: manager)}
  end

  @impl true
  def handle_info({:push_chart, chart}, socket) do
    {:noreply, push_event(socket, "chart:update", %{data: chart})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.flash_group flash={@flash} />

    <div data-theme={(@theme == :dark && "dark") || "light"}>
      <div class="min-h-screen flex items-center justify-center px-4 py-12">
        <div class="w-full max-w-5xl text-center">
          <div
            id="chart"
            phx-hook="Chart"
            phx-update="ignore"
            class="mt-6 mx-auto"
            style="position:relative; width:80vw; max-width:1200px; min-width:360px; height:45vh; display:block;"
            data-chart-config={
              Jason.encode!(%{
                type: "line",
                data: SeriesManager.to_chart(@manager),
                options: %{
                  responsive: true,
                  maintainAspectRatio: false,
                  animation: false,
                  interaction: %{mode: "nearest", intersect: false},
                  plugins: %{legend: %{display: false}},
                  elements: %{point: %{radius: 0, hoverRadius: 6}},
                  scales: %{
                    x: %{ticks: %{display: false}, grid: %{display: false}},
                    y: %{grid: %{display: true, drawTicks: true}, min: @ymin, max: @ymax}
                  }
                }
              })
            }
          >
            <canvas style="width:100%; height:100%; display:block;"></canvas>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
