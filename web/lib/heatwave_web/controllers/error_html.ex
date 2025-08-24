defmodule HeatwaveWeb.ErrorHTML do
  use HeatwaveWeb, :html

  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
