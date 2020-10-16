defmodule SuumWeb.PageController do
  use SuumWeb, :controller

  def index(conn, _parms) do
    render(conn, "index.html", rooms: Suum.Organizer.list_rooms())
  end
end
