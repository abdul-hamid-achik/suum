defmodule Suum.Hls.Transmission do
  use Suum.Schema
  use Waffle.Ecto.Schema

  alias Suum.{Accounts.User, Hls.Segment}

  @required [
    :name,
    :type,
    :user
  ]

  @optional []

  defenum(Type, ["live", "vod"])

  schema "tranmissions" do
    field(:name, :string)
    field :type, Type
    belongs_to :user, User

    has_many(:segment, Segment)
    timestamps()
  end

  def changeset(transmission, attrs) do
    transmission
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> put_assoc(:user, attrs.user)
  end
end
