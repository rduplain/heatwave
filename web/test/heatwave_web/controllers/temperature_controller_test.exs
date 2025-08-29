defmodule HeatwaveWeb.TemperatureControllerTest do
  use HeatwaveWeb.ConnCase, async: true
  alias Heatwave.{Repo, Sensor}

  @fixture %{
    sensor: "test-sensor-1",
    key: "test-api-key-123"
  }

  setup do
    sensor = %Sensor{sensor: @fixture.sensor, key: @fixture.key}
    Repo.insert!(sensor)

    {:ok, sensor: sensor}
  end

  describe "POST /value successfully" do
    test "creates temperature", %{conn: conn} do
      conn =
        conn
        |> put_req_header("x-api-key", @fixture.key)
        |> put_req_header("content-type", "text/plain")
        |> post("/value", "75.5")

      assert response(conn, 204)
    end

    test "handles extra whitespace", %{conn: conn} do
      conn =
        conn
        |> put_req_header("x-api-key", @fixture.key)
        |> put_req_header("content-type", "text/plain")
        |> post("/value", "  85.0  \n ")

      assert response(conn, 204)
    end
  end

  describe "POST /value returns Bad Request" do
    test "when value is not a valid float", %{conn: conn} do
      conn =
        conn
        |> put_req_header("x-api-key", @fixture.key)
        |> put_req_header("content-type", "text/plain")
        |> post("/value", "not-a-number")

      assert response(conn, 400)
      assert response_content_type(conn, :text) =~ "text/plain"
      assert response_body(conn) =~ "Provide a numeric value"
    end

    test "when request body is empty", %{conn: conn} do
      conn =
        conn
        |> put_req_header("x-api-key", @fixture.key)
        |> put_req_header("content-type", "text/plain")
        |> post("/value", "")

      assert response(conn, 400)
      assert response_body(conn) =~ "Provide a numeric value"
    end

    test "when request body is only whitespace", %{conn: conn} do
      conn =
        conn
        |> put_req_header("x-api-key", @fixture.key)
        |> put_req_header("content-type", "text/plain")
        |> post("/value", "   \n\t   ")

      assert response(conn, 400)
      assert response_body(conn) =~ "Provide a numeric value"
    end

    test "when value is out of range", %{conn: conn} do
      conn =
        conn
        |> put_req_header("x-api-key", @fixture.key)
        |> put_req_header("content-type", "text/plain")
        |> post("/value", "150.0")

      assert response(conn, 400)
      assert response_body(conn) =~ "between"
    end

    test "when value is negative and out of range", %{conn: conn} do
      conn =
        conn
        |> put_req_header("x-api-key", @fixture.key)
        |> put_req_header("content-type", "text/plain")
        |> post("/value", "-10.0")

      assert response(conn, 400)
      assert response_body(conn) =~ "between"
    end
  end

  describe "POST /value returns Content Too Large" do
    test "when request has 10MB body", %{conn: conn} do
      large_body = String.duplicate("x", 10_000_000)

      conn =
        conn
        |> put_req_header("x-api-key", @fixture.key)
        |> put_req_header("content-type", "text/plain")
        |> put_req_header("content-length", "10000000")
        |> post("/value", large_body)

      # A large enough body should trigger conn's :more result.
      assert response(conn, 413)
      assert response_body(conn) =~ "Content Too Large"
    end
  end

  describe "POST /value handles bad API authorization" do
    test "when API key is missing", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "text/plain")
        |> post("/value", "75.0")

      assert response(conn, 400)
      assert response_body(conn) =~ "Provide X-API-KEY"
    end

    test "when API key is invalid", %{conn: conn} do
      conn =
        conn
        |> put_req_header("x-api-key", "invalid-key")
        |> put_req_header("content-type", "text/plain")
        |> post("/value", "75.0")

      assert response(conn, 403)
      assert response_body(conn) =~ "Forbidden"
    end
  end

  defp response_body(conn) do
    conn.resp_body || ""
  end
end
