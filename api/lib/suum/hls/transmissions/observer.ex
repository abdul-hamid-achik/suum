defmodule Suum.Hls.Transmissions.Observer do
  use GenServer
  require Logger
  alias Suum.Hls.Jobs.UpsertMediaElement

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast(
        :sync,
        %{transmission_uuid: uuid, transmissions_base_path: transmissions_base_path} = state
      ) do
    playlist = get_playlist(transmissions_base_path, uuid)
    thumbnails = get_thumbnails(transmissions_base_path, uuid)

    {:ok, pid} = FileSystem.start_link(dirs: [playlist], name: :playlist)
    FileSystem.subscribe(pid)

    {:noreply,
     Map.merge(state, %{
       transmission_uuid: uuid,
       pid: pid,
       thumbnails: thumbnails,
       playlist: playlist,
       processed_lines: []
     })}
  end

  def handle_cast(
        {:process, %{filename: filename, filetype: "video/" <> filetype, uid: uid}},
        %{transmission_uuid: uuid, transmissions_base_path: transmissions_base_path} = state
      )
      when not is_nil(uuid) do
    file_dir =
      uid
      |> String.slice(0..2)
      |> String.split("")
      |> Enum.reject(&(&1 == ""))
      |> Enum.join("/")

    transmission_path = "#{transmissions_base_path}/#{uuid}"
    video_file_path = "#{transmission_path}/#{filename}"

    _create_dir = Porcelain.exec("mkdir", ["-p", transmission_path])

    _rename_file =
      Porcelain.exec("mv", [
        "#{transmissions_base_path}/#{file_dir}/#{uid}",
        "#{video_file_path}"
      ])

    opts = [
      "-i",
      video_file_path,
      "-b:a 192k",
      "-b:v 4000k",
      "-c:a aac",
      "-c:v libx264",
      "-f hls",
      "-hls_list_size 0",
      "-hls_time 4",
      "-hls_playlist_type vod",
      "-hls_segment_filename #{transmission_path}/%s.ts",
      "-strftime 1",
      "-y #{transmission_path}/index.m3u8"
    ]

    IO.inspect("ffmpeg #{Enum.join(opts, " ")}")

    _result =
      Porcelain.exec(
        "ffmpeg",
        opts
      )

    GenServer.cast(self(), :sync)
    {:noreply, Map.merge(state, %{filename: filename, filetype: filetype, file_uid: uid})}
  end

  def handle_cast(
        :stop,
        %{
          thumbnails: thumbnails,
          transmission_uuid: uuid,
          transmissions_base_path: transmissions_base_path
        } = state
      ) do
    save_thumbnails(thumbnails, uuid, transmissions_base_path)
    {:noreply, state}
  end

  @impl true
  def handle_info(
        {:file_event, _watcher_pid, {playlist, _events}},
        %{
          transmission_uuid: uuid,
          processed_lines: processed_lines,
          transmissions_base_path: transmissions_base_path
        } = state
      ) do
    acc = []
    {:ok, raw} = File.read(playlist)

    lines = raw |> String.split("\n") |> Enum.with_index()

    case lines
         |> Enum.reject(&Enum.member?(processed_lines, &1))
         |> Enum.reduce(acc, &parse_segment(&1, &2, lines, uuid, transmissions_base_path))
         |> enqueue_upsert(:segment) do
      :ok ->
        Logger.info("Enqueuing jobs to save segments")
    end

    {:noreply, Map.merge(state, %{processed_lines: lines})}
  end

  def handle_info({:file_event, watcher_pid, :stop}, state) do
    # Your own logic when monitor stop
    IO.inspect({watcher_pid}, label: "handle info file events  STOP")
    {:noreply, state}
  end

  defp save_thumbnails(thumbnails, uuid, transmissions_base_path) do
    Logger.info("Received order to save #{thumbnails}")
    acc = []
    {:ok, raw} = File.read(thumbnails)
    lines = String.split(raw, "\n")

    case lines
         |> Enum.reduce(acc, &parse_thumbnail(&1, &2, uuid, transmissions_base_path))
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
         transmissions_base_path
       ) do
    {file, _i} = Enum.at(lines, i + 1)
    [timestamp_raw | _] = String.split(file, ".ts")
    timestamp = String.to_integer(timestamp_raw)
    file = "#{transmissions_base_path}/#{uuid}/#{file}"

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

  defp get_playlist(transmissions_base_path, transmission_uuid),
    do: "#{transmissions_base_path}/#{transmission_uuid}/index.m3u8"

  defp get_thumbnails(transmissions_base_path, transmission_uuid),
    do: "#{transmissions_base_path}/#{transmission_uuid}/thumbnails.txt"
end
