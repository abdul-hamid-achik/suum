defmodule SuumWeb.Api.Mutations.Account do
  use Absinthe.Schema.Notation
  alias SuumWeb.Api.Resolvers

  object :account_mutations do
    @desc "Sign up"
    field :signup, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      arg(:password_confirmation, non_null(:string))

      resolve(&Resolvers.Accounts.signup/3)
    end

    @desc "Sign In"
    field :signin, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Accounts.signin/3)
    end
  end
end
