defmodule SuumWeb.TransmissionController do
  use SuumWeb, :controller
  require Logger

  alias Suum.Hls

  def vod(conn, %{"uuid" => uuid} = _params) do
    Logger.info("VOD - #{uuid}")
    transmission = Hls.get_transmission(uuid)

    segments =
      Enum.map(
        Hls.filter_segments(transmission_uuid: transmission.uuid),
        &(&1
          |> Hls.Segment.set_url()
          |> Hls.Segment.set_duration_sec())
      )

    Logger.info(inspect(Enum.map(segments, & &1.uuid), pretty: true))

    transmission =
      Map.put(
        transmission,
        :segments,
        segments
      )

    Logger.info("Segments loaded #{length(segments)}")

    targetduration = segments |> Enum.map(& &1.duration) |> max()

    conn
    |> put_resp_content_type("application/vnd.apple.mpegurl")
    |> put_resp_header("accept-ranges", "bytes")
    |> render("vod.m3u8", transmission: transmission, targetduration: targetduration || 30)
  end

  def thumbnails(conn, %{"uuid" => uuid} = _params) do
    Logger.info("Generating Thumbnails VTT for Transmission #{uuid}")

    transmission =
      uuid
      |> Hls.get_transmission()
      |> Hls.Transmission.set_sprite()

    thumbnails =
      Enum.map(
        Enum.with_index(Hls.filter_thumbnails(transmission_uuid: transmission.uuid)),
        &(&1
          |> elem(0)
          |> Hls.Thumbnail.set_url()
          |> Hls.Thumbnail.set_time(elem(&1, 1)))
      )

    Logger.info("Thumbnails loaded #{length(thumbnails)}")

    conn
    |> put_resp_content_type("text/vtt")
    |> put_resp_header("accept-ranges", "bytes")
    |> render("thumbnails.vtt", thumbnails: thumbnails, transmission: transmission)
  end

  defp max([a]), do: a
  defp max([head | tail]), do: Enum.reduce(tail, head, &check_big/2)
  defp max([]), do: nil

  defp check_big(a, b) when a > b, do: a
  defp check_big(a, b) when a <= b, do: b
end
