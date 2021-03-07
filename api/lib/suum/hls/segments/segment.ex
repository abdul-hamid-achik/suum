defmodule Suum.Hls.Segment do
  alias Suum.Hls.Transmission

  use Suum.Schema
  use Waffle.Ecto.Schema

  @required [
    :file,
    :time_start,
    :time_end,
    :duration,
    :transmission
  ]

  @optional []

  schema "segments" do
    field(:file, Suum.Uploaders.Segment.Type)
    field(:time_end, :utc_datetime)
    field(:time_start, :utc_datetime)
    field(:duration, :integer)

    belongs_to(:transmission, Transmission)
    timestamps()
  end

  def changeset(segment, attrs) do
    segment
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> put_assoc(:tranmission, attrs.transmission)
  end
end
