defmodule Suum.Hls.Jobs.UpsertMediaElement do
  use TaskBunny.Job
  require Logger
  alias Suum.Hls.{Thumbnails, Thumbnail, Segments, Segment}

  defp validate("thumbnail", attrs), do: Thumbnail.changeset(%Thumbnail{}, attrs)
  defp validate("segment", attrs), do: Segment.changeset(%Segment{}, attrs)

  defp create("thumbnail", attrs), do: Thumbnails.create_thumbnail(attrs)
  defp create("segment", attrs), do: Segments.create_segment(attrs)

  def perform(%{"type" => type, "attrs" => attrs}) do
    # TODO: implement a get_or_create feature or upsert instead of create
    with %Ecto.Changeset{valid?: true} <- validate(type, attrs),
         {:ok, media_element} <- create(type, attrs) do
      Logger.info("Uploaded #{type} #{media_element.uuid}")
      :ok
    else
      error ->
        Logger.error("Problem ocurred #{inspect(error, pretty: true)}")
        :ok
    end
  end
end
