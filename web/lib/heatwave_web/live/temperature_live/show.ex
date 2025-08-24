defmodule HeatwaveWeb.TemperatureLive.Show do
  use HeatwaveWeb, :live_view

  alias Heatwave.TemperatureController

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Temperature {@temperature.id}
        <:subtitle>This is a temperature record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/temperatures"}>
            <.icon name="hero-arrow-left" />
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Sensor">{@temperature.sensor}</:item>
        <:item title="Value">{@temperature.value}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Temperature")
     |> assign(:temperature, TemperatureController.get_temperature!(id))}
  end
end
