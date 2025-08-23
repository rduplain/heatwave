defmodule HeatwaveWeb.PageController do
  use HeatwaveWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
