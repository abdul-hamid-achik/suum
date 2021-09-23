defmodule Suum.Hls.Jobs.CreateSprite do
  use TaskBunny.Job
  require Logger

  alias Suum.Hls

  def perform(transmission_uuid) do
    transmission = Hls.get_transmission(transmission_uuid)

    Logger.info(
      "Generating Sprite for transmission - #{transmission.uuid} - #{transmission.name}"
    )

    thumbnails = Hls.filter_thumbnails(transmission_uuid: transmission_uuid)

    case create_sprite(thumbnails, transmission_uuid) do
      :error ->
        Logger.error("No thumbnails found")

      sprite ->
        Logger.info("Saving generated sprite #{inspect(sprite, pretty: true)}")

        {:ok, _transmission} = Hls.update_transmission(transmission, %{sprite: sprite})
    end
  end

  defp create_sprite(thumbnails, _) when is_list(thumbnails) and length(thumbnails) == 0,
    do: :error

  defp create_sprite(thumbnails, transmission_uuid) do
    tmp_dir = System.tmp_dir!()
    Logger.info("Thumbnails - #{length(thumbnails)}")

    base_path = "#{tmp_dir}#{transmission_uuid}"
    File.mkdir_p(base_path)
    Logger.info("Created Folder - #{base_path}")

    thumbnails
    |> resize(base_path)
    |> analyze(base_path)

    sprite = "#{base_path}/#{transmission_uuid}_sprite.png"
    montage(base_path, sprite)
    compress(sprite)
    sprite
  end

  defp resize(thumbnails, base_path) do
    listed_thumbnails =
      thumbnails
      |> Enum.map(&Hls.Thumbnail.set_url(&1))
      |> Enum.map(&download(&1, base_path))
      |> Enum.map(&get_file_path(&1, base_path))
      |> Enum.join(" ")

    command = ~w(mogrify -geometry 100x #{listed_thumbnails})

    Logger.info("resizing - #{listed_thumbnails}")
    {:ok, _pid, _} = :exec.run(command, [:debug])
    thumbnails
  end

  defp analyze(thumbnails, base_path) do
    Enum.map(thumbnails, fn thumbnail ->
      file = get_file_path(thumbnail, base_path)

      command = ~w(identify -format "%g - %f" #{file})

      Logger.info("analyzing - #{inspect(thumbnail, pretty: true)}")
      {:ok, [out]} = :exec.run(command, [:stdout])
      {:ok, thumbnail} = Hls.Thumbnail.set_analyzis(thumbnail, out)
      thumbnail
    end)
  end

  defp montage(base_path, sprite) do
    command = ~w(
      montage
      #{base_path}/*.jpeg
      -tile
      2x2
      -geometry
      100x55+0+0
      #{sprite}
    )

    {:ok, [out]} = :exec.run(command, [:stdout])
    out
  end

  defp compress(sprite) do
    {:ok, [out]} = :exec.run("optipng #{sprite}", [:stdout])
    out
  end

  defp download(thumbnail, tmp_dir) do
    {:ok, response} = Tesla.get(thumbnail.url)
    file_path = get_file_path(thumbnail, tmp_dir)
    File.write!(file_path, response.body)
    Logger.info("downloaded - #{file_path}")
    thumbnail
  end

  defp get_file_path(thumbnail, base_path),
    do: "#{base_path}/#{thumbnail.uuid}.jpeg"
end
