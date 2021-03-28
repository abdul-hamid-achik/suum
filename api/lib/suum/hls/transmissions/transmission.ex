defmodule Suum.Hls.Transmission do
  use Suum.Schema
  use Waffle.Ecto.Schema

  alias Suum.{Accounts.User, Hls.Segment, Uploaders}

  @required [
    :name,
    :user_uuid,
    :slug
  ]

  @optional [
    :type
  ]

  defenum(Type, ["live", "vod"])

  schema "transmissions" do
    field(:name, :string)
    field(:slug, :string)
    field :type, Type, default: :live
    field(:sprite, Suum.Uploaders.Sprite.Type)
    field(:sprite_url, :string, virtual: true)
    field(:preview, Suum.Uploaders.Preview.Type)
    field(:preview_url, :string, virtual: true)

    belongs_to :user, User,
      foreign_key: :user_uuid,
      references: :uuid

    has_many(:segments, Segment)
    timestamps()
  end

  def set_sprite(transmission),
    do:
      Map.put(
        transmission,
        :sprite_url,
        Uploaders.Sprite.url({transmission.sprite, transmission}, :original, signed: true)
      )

  def set_preview(transmission),
    do:
      Map.put(
        transmission,
        :preview_url,
        Uploaders.Preview.url({transmission.preview, transmission}, :original, signed: true)
      )

  def changeset(transmission, attrs) do
    transmission
    |> cast(attrs, @required ++ @optional)
    |> slugify(:name)
    |> unique_constraint(:slug, name: :transmissions_slug_index)
    |> validate_required(@required)
    |> cast_attachments(attrs, [:sprite, :preview])
    |> foreign_key_constraint(:user_uuid)
  end
end
