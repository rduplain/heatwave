defmodule HeatwaveWeb.Error do
  defexception [:code, :msg]

  @status %{
    bad_request: 400,
    too_large: 413,
    server_error: 500,
    not_found: 404
  }

  def new(code, msg) when is_binary(msg) do
    %__MODULE__{code: code, msg: msg}
  end

  def message(%__MODULE__{msg: msg}), do: msg

  def respond(conn, %__MODULE__{code: code, msg: msg}, content_type \\ "text/plain") do
    conn
    |> Plug.Conn.put_resp_content_type(content_type)
    |> Plug.Conn.send_resp(@status[code], msg)
  end

  def bad_request(msg \\ "Bad Request"), do: new(:bad_request, msg)
  def server_error(msg \\ "Internal Server Error"), do: new(:server_error, msg)
  def not_found(msg \\ "Not Found"), do: new(:not_found, msg)
  def too_large(msg \\ "Content Too Large"), do: new(:too_large, msg)
end
