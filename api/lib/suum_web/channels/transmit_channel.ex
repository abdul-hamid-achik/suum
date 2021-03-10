defmodule SuumWeb.TransmitChannel do
  use Phoenix.Channel
  import Suum.Factory
  require Logger

  alias Suum.Hls.Transmissions.Observer

  @ffmpeg_args ~w(-i - -c:v libx264 -preset veryfast -tune zerolatency -c:a aac -ar 44100 -b:a 64k -y -use_wallclock_as_timestamps 1 -async 1 -bufsize 1000 -f flv)

  @impl true
  def join("transmit:video", _message, socket) do
    {:ok, pid} = Observer.start_link([])
    {:ok, assign(socket, :observer_pid, pid)}
  end

  @impl true
  def terminate(reason, _socket) do
    Logger.error("Exited #{inspect(reason)}")
    :ok
  end

  def handle_in(
        "stop",
        _,
        %{
          assigns: %{
            porcelain_process: porcelain_process,
            observer_pid: pid,
            transmission_uuid: uuid
          }
        } = socket
      ) do
    Porcelain.Process.stop(porcelain_process)
    GenServer.cast(pid, {:save, uuid})
    {:noreply, assign(socket, Map.delete(socket.assigns, :porcelain_process))}
  end

  def handle_in("start", _, socket) do
    transmission = insert(:transmission)

    assigns = %{
      porcelain_process: spawn_ffmpeg(transmission.uuid),
      transmission_uuid: transmission.uuid
    }

    {:noreply,
     assign(
       socket,
       Map.merge(socket.assigns, assigns)
     )}
  end

  @impl true
  def handle_in(
        "segment",
        %{"data" => "data:video/x-matroska;codecs=avc1,opus;base64," <> data},
        socket
      ) do
    Porcelain.Process.send_input(socket.assigns.porcelain_process, Base.decode64!(data))
    {:noreply, socket}
  end

  @impl true
  def handle_in(
        "segment",
        %{"data" => "data:video/webm;codecs=vp8;base64," <> data},
        socket
      ) do
    Porcelain.Process.send_input(socket.assigns.porcelain_process, Base.decode64!(data))
    {:noreply, socket}
  end

  defp spawn_ffmpeg(transmission_uuid) do
    Porcelain.spawn("ffmpeg", @ffmpeg_args ++ ["#{rtmp_host()}/live/#{transmission_uuid}"])
  end

  defp rtmp_host, do: System.get_env("RTMP_HOST", "rtmp://localhost:1935")
end
