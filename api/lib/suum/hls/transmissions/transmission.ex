defmodule Suum.Hls.Transmission do
  use Suum.Schema
  use Waffle.Ecto.Schema

  require Logger
  alias Suum.{Accounts.User, Hls.Segment, Uploaders}

  @required [
    :name,
    :user_uuid,
    :slug
  ]

  @optional [
    :type,
    :ip_address,
    :state,
    :upload_name,
    :content_type,
    :uid
  ]

  defenum(Type, ["live", "vod"])

  schema "transmissions" do
    field(:name, :string)
    field(:slug, :string)
    field(:description, :string)
    field :tags, {:array, :string}
    field :ready?, :boolean, default: false
    field(:sprite, Uploaders.Image.Type)
    field(:preview, Uploaders.Image.Type)
    field :type, Type, default: :live
    field(:presigned_sprite_url, :string, virtual: true)
    field(:presigned_preview_url, :string, virtual: true)

    belongs_to :user, User,
      foreign_key: :user_uuid,
      references: :uuid

    has_many(:segments, Segment)
    timestamps()
  end

  @spec set_sprite(%{:sprite => any, optional(any) => any}) :: %{
          :sprite => any,
          :presigned_sprite_url => any,
          optional(any) => any
        }
  def set_sprite(transmission),
    do:
      Map.put(
        transmission,
        :presigned_sprite_url,
        Uploaders.Sprite.url({transmission.sprite, transmission}, :original, signed: true)
      )

  @spec set_preview(%{:preview => any, optional(any) => any}) :: %{
          :preview => any,
          :presigned_preview_url => any,
          optional(any) => any
        }
  def set_preview(transmission),
    do:
      Map.put(
        transmission,
        :presigned_preview_url,
        Uploaders.Preview.url({transmission.preview, transmission}, :original, signed: true)
      )

  def set_upload(
        transmission,
        %{
          upload_name: upload_name,
          content_type: content_type,
          uid: uid
        } = params
      )
      when not is_nil(upload_name) and not is_nil(content_type) and not is_nil(uid) do
    Map.merge(transmission, params)
  end

  def changeset(transmission, attrs) do
    transmission
    |> cast(attrs, @required ++ @optional)
    |> slugify(:name)
    |> validate_required(@required)
    |> cast_attachments(attrs, [:sprite, :preview])
    |> foreign_key_constraint(:user_uuid)
  end
end
