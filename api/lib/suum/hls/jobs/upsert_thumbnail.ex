defmodule Suum.Hls.Jobs.UpsertThumbnail do
  use TaskBunny.Job
  require Logger
  alias Suum.Hls.{Thumbnails, Thumbnail}

  def perform(attrs) do
    Logger.info("Starting Upsert of #{inspect(attrs, pretty: true)}")

    with %Ecto.Changeset{valid?: true} = _changeset <- Thumbnail.changeset(%Thumbnail{}, attrs),
         {:ok, thumbnail} <- Thumbnails.create_thumbnail(attrs) do
      Logger.info("Uploaded #{inspect(thumbnail.file, pretty: true)}")
      :ok
    else
      error ->
        Logger.error("Problem ocurred #{error}")
        :ok
    end
  end
end
