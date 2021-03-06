defmodule Suum.Hls.Segment do
  alias Suum.Hls.Transmision

  use Suum.Schema
  use Waffle.Ecto.Schema

  @derive {Inspect, except: []}

  schema "segments" do
    field(:file, Suum.Uploaders.Segment.Type)
    field(:time_end, :utc_datetime)
    field(:time_start, :utc_datetime)
    field(:duration, :integer)

    belongs_to(:transmision, Transmision)
    timestamps()
  end
end
