defmodule Suum.Hls.Jobs.UpsertSegment do
  use TaskBunny.Job

  alias Suum.Hls.{Segments, Segment}

  def perform(attrs) do
    with %Ecto.Changeset{valid?: true} = _changeset <- Segments.changeset(%Segment{}, attrs),
         {:ok, segment} <- Segments.create_segment(attrs) do
      :ok
    end
  end
end
