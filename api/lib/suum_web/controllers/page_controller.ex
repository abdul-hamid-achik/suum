defmodule SuumWeb.PageController do
  use SuumWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
