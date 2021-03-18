defmodule Suum.Hls.Transmission do
  use Suum.Schema
  use Waffle.Ecto.Schema

  alias Suum.{Accounts.User, Hls.Segment, Uploaders}

  @required [
    :name,
    :type,
    :user_uuid
  ]

  @optional []

  defenum(Type, ["live", "vod"])

  schema "transmissions" do
    field(:name, :string)
    field :type, Type
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

  def changeset(transmission, attrs) do
    transmission
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> cast_attachments(attrs, [:sprite])
    |> foreign_key_constraint(:user_uuid)
  end
end
