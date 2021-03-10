defmodule SuumWeb.TransmissionController do
  use SuumWeb, :controller
  require Logger

  alias Suum.Hls

  def vod(conn, %{"uuid" => uuid} = _params) do
    Logger.info("VOD - #{uuid}")
    transmission = Hls.get_transmission(uuid)

    segments =
      Enum.map(
        Hls.list_segments(transmission_uuid: transmission.uuid),
        &(&1
          |> Hls.Segment.set_file_url()
          |> Hls.Segment.set_duration_sec())
      )

    transmission =
      Map.put(
        transmission,
        :segments,
        segments
      )

    Logger.info("Segments loaded #{length(segments)}")

    conn
    |> put_resp_content_type("application/vnd.apple.mpegurl")
    |> put_resp_header("accept-ranges", "bytes")
    |> render("vod.m3u8", transmission: transmission)
  end

  def thumbnails(conn, %{"uuid" => uuid} = _params) do
    Logger.info("Generating Thumbnails VTT for Transmission #{uuid}")
    transmission = Hls.get_transmission(uuid)

    thumbnails =
      Enum.map(
        Enum.with_index(Hls.list_thumbnails(transmission_uuid: transmission.uuid)),
        &(&1
          |> elem(0)
          |> Hls.Thumbnail.set_file_url()
          |> Hls.Thumbnail.set_time(elem(&1, 1)))
      )

    Logger.info("Thumbnails loaded #{length(thumbnails)}")

    conn
    |> put_resp_content_type("text/vtt")
    |> put_resp_header("accept-ranges", "bytes")
    |> render("thumbnails.vtt", thumbnails: thumbnails)
  end
end
