defmodule Suum.Hls.Transmision do
  use Suum.Schema
  use Waffle.Ecto.Schema

  alias Suum.{Accounts.User, Hls.Segment}

  defenum(Type, ["live", "vod"])

  @derive {Inspect, except: []}
  schema "tranmissions" do
    field(:name, :string)
    field :type, Type
    belongs_to :user, User

    has_many(:segment, Segment)
    timestamps()
  end
end
