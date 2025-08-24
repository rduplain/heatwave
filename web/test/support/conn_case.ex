defmodule HeatwaveWeb.ConnCase do
  @moduledoc """
  Set up test connection (i.e. to web endpoint).
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      @endpoint HeatwaveWeb.Endpoint

      use HeatwaveWeb, :verified_routes

      import Plug.Conn
      import Phoenix.ConnTest
      import HeatwaveWeb.ConnCase
    end
  end

  setup tags do
    Heatwave.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
