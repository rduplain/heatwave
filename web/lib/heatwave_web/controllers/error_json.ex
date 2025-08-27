defmodule HeatwaveWeb.ErrorJSON do
  @moduledoc "Render JSON error response, by convention."
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
