defmodule HeatwaveWeb.Router do
  use HeatwaveWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HeatwaveWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HeatwaveWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/temperatures", TemperatureLive.Index, :index
    live "/temperatures/new", TemperatureLive.Form, :new
  end

  # Note: Add authentication before including LiveDashboard in production.
  #       e.g. served over HTTPS with Plug.BasicAuth.
  if Application.compile_env(:heatwave, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HeatwaveWeb.Telemetry
    end
  end
end
