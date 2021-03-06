defmodule SuumWeb.TransmitChannel do
  use Phoenix.Channel

  @impl true
  def join("transmit:video", _message, socket) do
    {:ok, assign(socket, :porcelain_process, spawn_ffmpeg())}
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

  # @impl true
  # def terminate(reason, socket) do
  #   IO.inspect(reason, label: "terminate reason")
  #   Exexec.kill(socket.assigns.pid, 9)
  # end

  defp spawn_ffmpeg() do
    ffmpeg_args =
      ~w(-i - -c:v libx264 -preset veryfast -tune zerolatency -c:a aac -ar 44100 -b:a 64k -y -use_wallclock_as_timestamps 1 -async 1 -bufsize 1000 -f flv)

    Porcelain.spawn("ffmpeg", ffmpeg_args ++ ["rtmp://localhost:1935/live"])
  end
end
