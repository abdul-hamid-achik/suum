defmodule SuumWeb.PageControllerTest do
  use SuumWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Suum · Video Calls"
  end
end
