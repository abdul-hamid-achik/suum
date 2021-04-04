defmodule SuumWeb.RtmpController do
  @transmissions_base_path "./mnt/hls/live"

  use SuumWeb, :controller
  require Logger
  alias Suum.{Hls.Jobs, Hls.Transmissions.Observer, Hls}

  @spec on_publish(Plug.Conn.t(), map) :: Plug.Conn.t()
  def on_publish(
        conn,
        %{
          "addr" => ip_address,
          "app" => _app,
          "call" => _call,
          "clientid" => _clientid,
          "flashver" => _flashver,
          "name" => transmission_uuid,
          "pageurl" => _pageurl,
          "swfurl" => _swurl,
          "tcurl" => _tcurl,
          "type" => _type
        } = _params
      ) do
    {:ok, pid} =
      Observer.start_link(%{
        transmission_uuid: transmission_uuid,
        transmissions_base_path: @transmissions_base_path
      })

    GenServer.cast(pid, :sync)
    transmission = Hls.get_transmission(transmission_uuid)

    {:ok, %Hls.Transmission{}} =
      Hls.update_transmission(transmission, %{
        pid: :erlang.pid_to_list(pid),
        ip_address: ip_address,
        type: :live
      })

    send_resp(conn, 200, "")
  end

  @spec on_publish_done(Plug.Conn.t(), map) :: Plug.Conn.t()
  def on_publish_done(conn, %{"name" => transmission_uuid, "call" => "done"} = _params) do
    Logger.info("VOD - #{transmission_uuid} | creating sprites")
    transmission = Hls.get_transmission(transmission_uuid)
    Hls.update_transmission(transmission, %{pid: nil, type: :vod})
    GenServer.call(:erlang.list_to_pid(transmission.pid), :stop)
    Jobs.CreateSprite.enqueue!(transmission_uuid)
    send_resp(conn, 200, "")
  end
end
