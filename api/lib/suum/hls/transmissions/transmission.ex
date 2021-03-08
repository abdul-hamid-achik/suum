defmodule Suum.Hls.Transmission do
  use Suum.Schema
  use Waffle.Ecto.Schema

  alias Suum.{Accounts.User, Hls.Segment}

  @required [
    :name,
    :type
    # :user_uuid
  ]

  @optional []

  defenum(Type, ["live", "vod"])

  schema "transmissions" do
    field(:name, :string)
    field :type, Type

    belongs_to :user, User,
      foreign_key: :user_uuid,
      references: :uuid

    has_many(:segments, Segment)
    timestamps()
  end

  def changeset(transmission, attrs) do
    transmission
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)

    # |> foreign_key_constraint(:user_uuid)
  end
end
