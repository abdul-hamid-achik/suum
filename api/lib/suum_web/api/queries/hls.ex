defmodule SuumWeb.Api.Queries.Hls do
  use Absinthe.Schema.Notation
  alias SuumWeb.Api.Resolvers

  object :hls_queries do
    @desc "Get all transmissions"
    field :list_transmissions, list_of(:transmission) do
      resolve(&Resolvers.Hls.list_transmissions/2)
    end
  end
end
