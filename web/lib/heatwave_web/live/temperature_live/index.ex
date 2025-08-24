defmodule HeatwaveWeb.TemperatureLive.Index do
  use HeatwaveWeb, :live_view

  alias Heatwave.TemperatureController

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Temperatures
        <:actions>
          <.button variant="primary" navigate={~p"/temperatures/new"}>
            <.icon name="hero-plus" /> New Temperature
          </.button>
        </:actions>
      </.header>

      <.table
        id="temperatures"
        rows={@streams.temperatures}
        row_click={fn {_id, temperature} -> JS.navigate(~p"/temperatures/#{temperature}") end}
      >
        <:col :let={{_id, temperature}} label="Sensor">{temperature.sensor}</:col>
        <:col :let={{_id, temperature}} label="Value">{temperature.value}</:col>
        <:action :let={{_id, temperature}}>
          <div class="sr-only">
            <.link navigate={~p"/temperatures/#{temperature}"}>Show</.link>
          </div>
          <.link navigate={~p"/temperatures/#{temperature}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, temperature}}>
          <.link
            phx-click={JS.push("delete", value: %{id: temperature.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Temperatures")
     |> stream(:temperatures, TemperatureController.list_temperatures())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    temperature = TemperatureController.get_temperature!(id)
    {:ok, _} = TemperatureController.delete_temperature(temperature)

    {:noreply, stream_delete(socket, :temperatures, temperature)}
  end
end
