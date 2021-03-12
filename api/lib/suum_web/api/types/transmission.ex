defmodule SuumWeb.Api.Types.Transmission do
  use Absinthe.Schema.Notation

  object :transmission do
    field(:uuid, :id)
    field(:user, :user)
    field(:name, :string)
    field(:type, :string)
    field(:segments, list_of(:segment))
    field(:sprite, :string)
  end
end
