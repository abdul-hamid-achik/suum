defmodule Suum.Hls do
  import Ecto.Query
  alias Suum.Hls.{Segments, Transmissions, Thumbnails}
  alias Suum.Hls.{Segment, Transmission, Thumbnail}

  defdelegate list_transmissions(lookup), to: Transmissions
  defdelegate get_transmission(uuid), to: Transmissions
  defdelegate update_transmission(thumbnail, attrs), to: Transmissions
  defdelegate list_thumbnails(lookup), to: Thumbnails
  defdelegate filter_thumbnails(lookup), to: Thumbnails
  defdelegate list_segments(lookup), to: Segments
  defdelegate filter_segments(lookup), to: Segments

  def data() do
    Dataloader.Ecto.new(Suum.Repo, query: &query/2)
  end

  def query(Transmission, _params), do: from(t in Transmission)
  def query(Thumbnail, _params), do: from(t in Thumbnail)
  def query(Segment, _params), do: from(t in Segment)
  def query(queryable, _params), do: queryable
end
