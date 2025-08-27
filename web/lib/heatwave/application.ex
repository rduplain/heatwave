defmodule Heatwave.Application do
  @moduledoc "Phoenix entrypoint."
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HeatwaveWeb.Telemetry,
      Heatwave.Repo,
      {Ecto.Migrator,
       repos: Application.fetch_env!(:heatwave, :ecto_repos), skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:heatwave, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Heatwave.PubSub},
      HeatwaveWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Heatwave.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    HeatwaveWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    System.get_env("RELEASE_NAME") == nil
  end
end
