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

    field(:url, :string, virtual: true)

    field(:width, :string, virtual: true)
    field(:height, :string, virtual: true)
    field(:x, :string, virtual: true)
    field(:y, :string, virtual: true)

    timestamps()
  end

  def changeset(thumbnail, attrs) do
    thumbnail
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> cast_attachments(attrs, [:file])
    |> foreign_key_constraint(:transmission_uuid)
  end

  def set_url(thumbnail) do
    Map.put(
      thumbnail,
      :url,
      Uploaders.Thumbnail.url({thumbnail.file, thumbnail}, :original, signed: true)
    )
  end

  @spec set_analyzis(__MODULE__.t(), String.t()) ::
          {:ok, __MODULE__.t()} | {:error, Ecto.Changeset.t()}
  def set_analyzis(thumbnail, output) do
    [dimensions, _] = String.split(output, " - ")
    [width, height_dirty] = String.split(dimensions, "x")

    [height, x, y] = String.split(height_dirty, "+")

    params = %{
      width: width,
      height: height,
      x: x,
      y: y
    }

    thumbnail
    |> changeset(params)
    |> apply_action(:insert)
  end

  def set_time(thumbnail, 0) do
    from = ~T[00:00:00.0]
    elapsed_seconds = 8
    to = Time.add(from, elapsed_seconds, :second)

    params = %{
      from: from,
      to: to
    }

    thumbnail
    |> changeset(params)
    |> apply_action(:insert)
  end

  def set_time(thumbnail, index) do
    start_seconds = index * 8
    from = Time.add(~T[00:00:00.0], start_seconds, :second)
    elapsed_seconds = 8 + start_seconds
    to = Time.add(from, elapsed_seconds, :second)

    params = %{
      from: from,
      to: to
    }

    thumbnail |> changeset(params) |> apply_action(:insert)
  end
end
