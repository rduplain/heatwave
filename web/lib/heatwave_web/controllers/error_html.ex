defmodule HeatwaveWeb.ErrorHTML do
  @moduledoc "Render HTML error page, by convention."
  use HeatwaveWeb, :html

  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
