defmodule Suum.Hls do
  alias Suum.Hls.{Segments, Transmissions, Thumbnails}

  defdelegate list_transmissions(lookup), to: Transmissions
  defdelegate get_transmission(uuid), to: Transmissions
  defdelegate list_thumbnails(lookup), to: Thumbnails
  defdelegate list_segments(lookup), to: Segments
end
