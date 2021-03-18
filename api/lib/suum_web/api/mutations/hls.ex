defmodule SuumWeb.Api.Mutations.Hls do
  use Absinthe.Schema.Notation
  alias SuumWeb.Api.{Resolvers, Middleware}

  object :hls_mutations do
    @desc "Create Transmission"
    field :create_transmission, :transmission do
      # TODO: Move this below to a input instead of args
      arg(:name, non_null(:string))
      arg(:type, non_null(:string))

      middleware(Middleware.Authenticate)
      resolve(&Resolvers.Hls.create_transmission/3)
    end
  end
end
