defmodule SuumWeb.Api.Queries.Account do
  use Absinthe.Schema.Notation
  alias SuumWeb.Api.Resolvers

  object :account_queries do
    @desc "Get the currently signed-in user"
    field :me, :user do
      resolve(&Resolvers.Accounts.me/3)
    end
  end
end
