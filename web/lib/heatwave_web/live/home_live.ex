defmodule HeatwaveWeb.HomeLive do
  use HeatwaveWeb, :live_view

  @theme :dark

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1_000, :tick)
    socket = assign(socket, count: 0, theme: @theme)
    {:ok, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply, update(socket, :count, &(&1 + 1))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.flash_group flash={@flash} />

    <div data-theme={(@theme == :dark && "dark") || "light"}>
      <div class="min-h-screen flex items-center justify-center px-4 py-12">
        <div class="max-w-md text-center">
          <h1 class="text-4xl font-bold">Hello, world!</h1>
          <div class="mt-6 text-5xl font-extrabold">{@count}</div>
        </div>
      </div>
    </div>
    """
  end
end
