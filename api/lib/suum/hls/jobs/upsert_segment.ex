defmodule Suum.Hls.Jobs.UpsertSegment do
  use TaskBunny.Job
  require Logger
  alias Suum.Hls.{Segments, Segment}

  def perform(attrs) do
    Logger.info("Starting Upsert of #{inspect(attrs, pretty: true)}")

    with %Ecto.Changeset{valid?: true} = _changeset <- Segment.changeset(%Segment{}, attrs),
         {:ok, segment} <- Segments.create_segment(attrs) do
      Logger.info("Uploaded #{inspect(segment.file, pretty: true)}")
      :ok
    else
      error ->
        Logger.error("Problem ocurred #{error}")
        :ok
    end
  end
end
