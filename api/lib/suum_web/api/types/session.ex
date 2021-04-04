defmodule SuumWeb.Api.Types.Session do
  use Absinthe.Schema.Notation

  object :session do
    field(:user, :user)
    field(:token, :string)
  end
end
