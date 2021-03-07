defmodule SuumWeb.Api.Types.User do
  use Absinthe.Schema.Notation

  object :user do
    field(:uuid, :id)
    field(:email, :string)
  end
end
