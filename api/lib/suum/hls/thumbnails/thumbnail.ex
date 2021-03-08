defmodule Suum.Hls.Thumbnail do
  alias Suum.{Hls.Transmission, Uploaders}

  use Suum.Schema
  use Waffle.Ecto.Schema

  @required [
    :file,
    :timestamp,
    :transmission_uuid
  ]

  @optional []

  schema "thumbnails" do
    field(:file, Suum.Uploaders.Thumbnail.Type)

    belongs_to(:transmission, Transmission,
      foreign_key: :transmission_uuid,
      references: :uuid,
      primary_key: true
    )

    field(:timestamp, :utc_datetime)
    field(:from, :string, virtual: true)
    field(:to, :string, virtual: true)

    field(:file_url, :string, virtual: true)

    timestamps()
  end

  def changeset(segment, attrs) do
    segment
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> cast_attachments(attrs, [:file])
    |> foreign_key_constraint(:transmission_uuid)
  end

  def set_file_url(segment),
    do: Map.put(segment, :file_url, Uploaders.Thumbnail.url({segment.file, segment}))

  def set_time(segment, 0) do
    from = ~T[00:00:00.0]
    elapsed_seconds = 8
    to = Time.add(from, elapsed_seconds, :second)

    Map.merge(segment, %{
      from: from,
      to: to
    })
  end

  def set_time(segment, index) do
    start_seconds = index * 8
    from = Time.add(~T[00:00:00.0], start_seconds, :second)
    elapsed_seconds = 8 + start_seconds
    to = Time.add(from, elapsed_seconds, :second)

    Map.merge(segment, %{
      from: from,
      to: to
    })
  end
end
