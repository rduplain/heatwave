defmodule HeatwaveWeb.Router do
  @moduledoc "Routing configuration for Phoenix."
  alias HeatwaveWeb.Plugs.SensorKey
  use HeatwaveWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HeatwaveWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :ingest do
    plug :accepts, ["text"]
    plug SensorKey
  end

  scope "/", HeatwaveWeb do
    pipe_through :browser
    live "/", HomeLive, :index
  end

  scope "/", HeatwaveWeb do
    pipe_through :ingest
    post "/value", ValueController, :create
  end
end
