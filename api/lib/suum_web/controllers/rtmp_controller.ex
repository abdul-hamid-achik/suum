defmodule SuumWeb.RtmpController do
  use SuumWeb, :controller
  require Logger

  alias Suum.Hls.Jobs

  def on_publish(conn, params) do
    IO.inspect(params)
    Logger.info("#{inspect(params)}")
    send_resp(conn, 200, "")
  end

  def on_done(conn, %{"name" => transmission_uuid, "call" => "done"} = _params) do
    Logger.info("VOD - #{transmission_uuid} | creating sprites")
    Jobs.CreateSprite.enqueue!(transmission_uuid)
    send_resp(conn, 200, "")
  end
end
