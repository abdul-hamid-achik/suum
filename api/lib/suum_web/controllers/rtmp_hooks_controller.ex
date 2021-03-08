defmodule SuumWeb.RtmpHooksController do
  use SuumWeb, :controller
  require Logger

  def on_play(conn, params) do
    IO.inspect(params)

    Logger.info("#{inspect(params)}")
    send_resp(conn, 302, "")
  end

  def on_publish(conn, params) do
    IO.inspect(params)
    Logger.info("#{inspect(params)}")
    send_resp(conn, 302, "")
  end

  def on_done(conn, params) do
    IO.inspect(params)
    Logger.info("#{inspect(params)}")
    send_resp(conn, 302, "")
  end
end
