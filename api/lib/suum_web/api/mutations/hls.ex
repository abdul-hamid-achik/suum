defmodule SuumWeb.Api.Mutations.Hls do
  use Absinthe.Schema.Notation
  alias SuumWeb.Api.Resolvers

  object :hls_mutations do
    @desc "Create Transmission"
    field :create_transmission, :transmission do
      arg(:name, non_null(:string))

      resolve(&Resolvers.Accounts.signup/3)
    end
  end
end
