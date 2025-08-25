#
# Status:   Ingest API is ready.
# Next Up:  Convert this "Hello, world!" to stream real data.
#
defmodule HeatwaveWeb.HomeLive do
  use HeatwaveWeb, :live_view

  @theme :dark

  @history 20
  @interval 1_000
  @ymax 120
  @ymin 32

  @count_demo 32

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(@interval, :tick)

    socket =
      assign(socket,
        chart: initial_chart(),
        count: @count_demo,
        theme: @theme,
        ymax: @ymax,
        ymin: @ymin
      )

    {:ok, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    socket = update(socket, :count, &(&1 + 1))

    count = socket.assigns.count
    chart = socket.assigns.chart

    labels = (chart.labels || []) ++ [""]

    labels = Enum.take(labels, -@history)

    datasets =
      for ds <- chart.datasets do
        Map.update!(ds, :data, fn d ->
          d = (d || []) ++ [count]
          Enum.take(d, -@history)
        end)
      end

    chart = %{chart | labels: labels, datasets: datasets}
    if connected?(socket), do: send(self(), {:push_chart, chart})

    {:noreply, assign(socket, chart: chart)}
  end

  @impl true
  def handle_info({:push_chart, chart}, socket) do
    {:noreply, push_event(socket, "chart:update", %{data: chart})}
  end

  defp initial_chart do
    labels = for _ <- 1..@history, do: ""
    data = for _ <- 1..@history, do: nil

    %{
      labels: labels,
      datasets: [
        %{
          label: "Count",
          data: data,
          fill: false
        }
      ]
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.flash_group flash={@flash} />

    <div data-theme={(@theme == :dark && "dark") || "light"}>
      <div class="min-h-screen flex items-center justify-center px-4 py-12">
        <div class="w-full max-w-5xl text-center">
          <h1 class="text-4xl font-bold">Hello, world!</h1>
          <div class="mt-6 text-5xl font-extrabold">{@count}</div>
          <div
            id="count-chart"
            phx-hook="Chart"
            phx-update="ignore"
            class="mt-6 mx-auto"
            style="position:relative; width:80vw; max-width:1200px; min-width:360px; height:45vh; display:block;"
            data-chart-config={
              Jason.encode!(%{
                type: "line",
                data: initial_chart(),
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
