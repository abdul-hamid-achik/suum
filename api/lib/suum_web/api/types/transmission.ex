defmodule SuumWeb.Api.Types.Transmission do
  use Absinthe.Schema.Notation

  object :tranmission do
    field(:user, :user)
    field(:name, :string)
    field(:type, :string)
    field(:segments, list_of(:segment))
  end
end
