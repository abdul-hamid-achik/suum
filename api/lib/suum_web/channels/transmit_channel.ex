defmodule SuumWeb.TransmitChannel do
  use Phoenix.Channel
  require Logger

  @ffmpeg_args ~w(-i - -c:v libx264 -preset veryfast -tune zerolatency -c:a aac -ar 44100 -b:a 64k -y -use_wallclock_as_timestamps 1 -async 1 -bufsize 1000 -f flv)

  @impl true
  def join("transmit:" <> transmission_uuid, _message, socket) do
    {:ok,
     assign(socket,
       transmission_uuid: transmission_uuid,
       porcelain_process: spawn_ffmpeg(transmission_uuid)
     )}
  end

  @impl true
  def terminate(reason, %{assigns: %{porcelain_process: porcelain_process}} = _socket)
      when not is_nil(porcelain_process) do
    Logger.error("Exited #{inspect(reason)}")
    Porcelain.Process.stop(porcelain_process)
    :ok
  end

  def terminate(reason, _) do
    Logger.error("Exited #{inspect(reason)}")
    :ok
  end

  @impl true
  def handle_in(
        "segment",
        %{"data" => "data:video/x-matroska;codecs=avc1,opus;base64," <> data},
        %{assigns: %{porcelain_process: porcelain_process}} = socket
      )
      when not is_nil(porcelain_process) and not is_nil(data) do
    Porcelain.Process.send_input(porcelain_process, Base.decode64!(data))
    {:noreply, socket}
  end

  def handle_in(
        "segment",
        %{"data" => "data:video/webm;codecs=vp8;base64," <> data},
        socket
      ) do
    Porcelain.Process.send_input(socket.assigns.porcelain_process, Base.decode64!(data))
    {:noreply, socket}
  end

  def handle_in(
        "segment",
        _params,
        socket
      ) do
    {:noreply, socket}
  end

  defp spawn_ffmpeg(transmission_uuid) do
    Porcelain.spawn("ffmpeg", @ffmpeg_args ++ ["#{rtmp_host()}/live/#{transmission_uuid}"])
  end

  defp rtmp_host, do: System.get_env("RTMP_HOST", "rtmp://localhost:1935")
end
