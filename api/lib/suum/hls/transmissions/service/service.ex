defmodule Suum.Hls.Transmissions.Service do
  use GenServer

  alias Suum.{
    Hls,
    Hls.Transmission,
    Hls.Transmissions.Service.State,
    Hls.Jobs.UpsertMediaElement
  }

  require Logger

  @default_interval 5_000

  def start_link(transmission),
    do:
      GenServer.start_link(
        __MODULE__,
        [
          transmission: transmission,
          segments: []
        ],
        name: process_name(transmission)
      )

  @impl true
  def init(args) do
    Logger.info("Initializing Transmission with args: #{inspect(args, pretty: true)}")
    Process.send_after(__MODULE__, :waiting, @default_interval)
    {:ok, args}
  end

  @impl true
  def handle_cast(
        {:created, %Transmission{}},
        state
      ) do
    {:noreply, state}
  end

  def handle_cast(
        {:waiting, %Transmission{}},
        state
      ) do
    keep_waiting()
    {:noreply, state}
  end

  def handle_cast(
        {:uploading, %Transmission{type: :vod}},
        state
      ) do
    {:noreply, state}
  end

  def handle_cast(
        {:streaming, %Transmission{type: :live, uuid: uuid} = transmission},
        state
      ) do
    Logger.info("Sync Playlist Request #{uuid}")
    playlist = get_playlist("./mnt/hls/live", uuid)
    {:ok, pid} = FileSystem.start_link(dirs: [playlist], name: :playlist)
    FileSystem.subscribe(pid)
    {:noreply, Keyword.merge(state, transmission: transmission)}
  end

  def handle_cast(
        {:streaming,
         %Transmission{
           type: :vod,
           uuid: uuid
         } = _transmission},
        %State{
          upload: %Upload{uuid: uid}
        } = state
      ) do
    file_dir =
      uid
      |> String.slice(0..2)
      |> String.split("")
      |> Enum.reject(&(&1 == ""))
      |> Enum.join("/")

    base_path = base_path(:vod)
    video_file_path = "#{base_path}/#{file_dir}/#{uid}"

    command = ~w(
      /usr/local/bin/ffmpeg
      -re
      -nostdin
      -i #{video_file_path}
      -vcodec libx264
      -preset:v ultrafast
      -acodec aac
      -f flv
      #{rtmp_host()}/live/#{uuid}
    )

    {:ok, _, _} = :exec.run(command, [:debug])

    Logger.info("Processing #{video_file_path}")
    {:noreply, state}
  end

  # def handle_cast(
  #       {:processing, %Transmission{type: :live, uuid: uuid} = transmission},
  #       state
  #     ) do
  #   Logger.info("Processing #{uuid}")
  #   base_path = base_path(:live)
  #   thumbnails = get_thumbnails(base_path, uuid)
  #   save_thumbnails(thumbnails, uuid, base_path)
  #   {:ok, _} = Transmission.transition_to(transmission, "ready")
  #   {:noreply, state}
  # end

  def handle_cast(
        {:processing, %Transmission{uuid: uuid} = transmission},
        state
      ) do
    Logger.info("Processing #{uuid}")
    base_path = base_path(:live)
    thumbnails = get_thumbnails(base_path, uuid)
    save_thumbnails(thumbnails, uuid, base_path)
    {:ok, _} = Transmission.transition_to(transmission, "ready")
    {:noreply, state}
  end

  def handle_cast(
        {:ready, %Transmission{name: name, type: type, uuid: uuid} = transmission},
        state
      ) do
    Logger.info("Ready to watch #{type} - #{uuid} | #{name}")
    {:ok} = Hls.update_transmission(transmission, %{ready?: true})
    GenServer.stop(self(), :normal, @default_interval)
    {:noreply, state}
  end

  def handle_cast(request, state) do
    Logger.warn("Unrecognized request #{inspect(request, pretty: true)}")
    {:noreply, state}
  end

  @impl true
  def handle_info(
        {:file_event, _watcher_pid, {playlist, events}},
        %State{
          segments: segments,
          transmission: %Transmission{} = transmission
        } = state
      ) do
    Logger.info("file event - #{playlist} -  #{inspect(events, pretty: true)}")
    next_segments = save_playlist(transmission, playlist, segments)

    with %Ecto.Changeset{valid?: true} = changeset <-
           State.changeset(state, %{segments: next_segments}),
         {:ok, state} <- State.upsert_segments(changeset, next_segments) do
      {:noreply, state}
    end
  end

  def handle_info(:waiting, state) do
    Logger.info("waiting....")
    transmissions = Hls.list_transmissions(%{state: "created"})
    Logger.info("found #{length(transmissions)} transmissions")

    keep_waiting()
    {:noreply, state}
  end

  def handle_info({:stdout, _os_pid, message}, state) do
    Logger.info(message)
    {:noreply, state}
  end

  def handle_info({:stderr, _os_pid, message}, state) do
    Logger.error(message)
    {:noreply, state}
  end

  def handle_info({:DOWN, _os_pid, :process, pid, :normal}, state) do
    Logger.warn("Attempting to exit")
    terminate(pid, :normal)
    {:noreply, state}
  end

  defp save_playlist(
         %Transmission{uuid: uuid} = _transmission,
         playlist_path,
         segments
       ) do
    acc = []
    {:ok, raw} = File.read(playlist_path)
    base_path = base_path(:live)
    lines = raw |> String.split("\n") |> Enum.with_index()

    next_segments =
      lines
      |> Enum.reject(&Enum.member?(segments, &1))
      |> Enum.reduce(acc, &parse_segment(&1, &2, lines, uuid, base_path))

    enqueue_upsert(next_segments, :segment)
    next_segments
  end

  defp save_thumbnails(thumbnails, uuid, base_path) do
    Logger.info("Received order to save #{thumbnails}")
    acc = []
    {:ok, raw} = File.read(thumbnails)
    lines = String.split(raw, "\n")

    case lines
         |> Enum.reduce(acc, &parse_thumbnail(&1, &2, uuid, base_path))
         |> enqueue_upsert(:thumbnail) do
      :ok ->
        Logger.info("Enqueuing jobs to save thumbails")
    end
  end

  defp parse_thumbnail("", thumbnails, _uuid, _transmissions_base_path), do: thumbnails

  defp parse_thumbnail(thumbnail, thumbnails, uuid, transmissions_base_path) do
    file = "#{transmissions_base_path}/#{uuid}/#{thumbnail}"
    [timestamp_raw | _] = String.split(thumbnail, ".jpeg")
    timestamp = String.to_integer(timestamp_raw)

    thumbnail = %{
      timestamp: DateTime.from_unix!(timestamp, :millisecond),
      file: file,
      transmission_uuid: uuid
    }

    [thumbnail | thumbnails]
  end

  defp parse_segment(
         {"#EXTINF:" <> duration_raw, i},
         segments,
         lines,
         uuid,
         base_path
       ) do
    {file, _i} = Enum.at(lines, i + 1)
    [timestamp_raw | _] = String.split(file, ".ts")
    timestamp = String.to_integer(timestamp_raw)
    file = "#{base_path}/#{uuid}/#{file}"

    segment = %{
      duration: trunc((duration_raw |> String.trim(",") |> String.to_float()) * 1000),
      timestamp: DateTime.from_unix!(timestamp, :millisecond),
      file: file,
      transmission_uuid: uuid
    }

    Logger.info("Processing #{file}")
    [segment | segments]
  end

  defp parse_segment(_line, segments, _lines, _, _) do
    segments
  end

  defp enqueue_upsert(segments, :segment),
    do: Enum.each(segments, &UpsertMediaElement.enqueue!(%{type: :segment, attrs: &1}))

  defp enqueue_upsert(thumbnails, :thumbnail),
    do: Enum.each(thumbnails, &UpsertMediaElement.enqueue!(%{type: :thumbnail, attrs: &1}))

  defp base_path(:live), do: "./mnt/hls/live"
  defp base_path(:vod), do: "./mnt/uploads"

  defp get_playlist(base_path, transmission_uuid),
    do: "#{base_path}/#{transmission_uuid}/index.m3u8"

  defp get_thumbnails(base_path, transmission_uuid),
    do: "#{base_path}/#{transmission_uuid}/thumbnails.txt"

  defp rtmp_host, do: System.get_env("RTMP_HOST", "rtmp://localhost:1935")

  defp process_name(transmission),
    do: {:via, Registry, {TransmissionRegistry, transmission.uuid}}

  defp keep_waiting, do: Process.send_after(__MODULE__, :waiting, @default_interval)
end
