defmodule SuumWeb.TransmitChannel do
  use Phoenix.Channel
  require Logger

  @impl true
  def join("transmit:" <> transmission_uuid, _message, socket) do
    {:ok,
     assign(socket,
       transmission_uuid: transmission_uuid,
       pid: spawn_ffmpeg(transmission_uuid)
     )}
  end

  @impl true
  def terminate(reason, %{assigns: %{pid: pid}} = _socket)
      when not is_nil(pid) do
    Logger.error("Exited #{inspect(reason)}")
    :exec.kill(pid, 0)
  end

  def terminate(reason, _) do
    Logger.error("Exited #{inspect(reason)}")
    :ok
  end

  @impl true
  def handle_in(
        "segment",
        %{"data" => "data:video/x-matroska;codecs=avc1,opus;base64," <> data},
        %{assigns: %{pid: pid}} = socket
      )
      when not is_nil(pid) and not is_nil(data) do
    :ok = :exec.send(pid, Base.decode64!(data))
    {:noreply, socket}
  end

  def handle_in(
        "segment",
        %{"data" => "data:video/webm;codecs=vp8;base64," <> data},
        %{assigns: %{pid: pid}} = socket
      ) do
    :ok = :exec.send(pid, Base.decode64!(data))
    {:noreply, socket}
  end

  def handle_in(
        "segment",
        _params,
        socket
      ) do
    Logger.warn("couldnt process segment")
    {:noreply, socket}
  end

  defp spawn_ffmpeg(transmission_uuid) do
    command = ~w(
      /usr/local/bin/ffmpeg
      -i pipe:0
      -hide_banner
      -stats
      -loglevel fatal
      -fflags nobuffer
      -rtsp_transport tcp
      -preset ultrafast
      -c:a copy
      -c:v copy
      -f flv
      #{rtmp_host()}/live/#{transmission_uuid}
    )

    Logger.info(command |> Enum.join(" "))
    {:ok, pid, _os_pid} = :exec.run_link(command, [:stdin, :debug])

    pid
  end

  @impl true
  def handle_info({:stderr, os_pid, message}, state) do
    Logger.error("#{inspect(os_pid)} - #{inspect(message)}")
    {:noreply, state}
  end

  def handle_info({:stdout, os_pid, message}, state) do
    Logger.info("#{inspect(os_pid)} - #{inspect(message)}")
    {:noreply, state}
  end

  def handle_info(request, state) do
    Logger.error("#{inspect(request, pretty: true)}")
    {:noreply, state}
  end

  defp rtmp_host, do: System.get_env("RTMP_HOST", "rtmp://localhost:1935")
end
