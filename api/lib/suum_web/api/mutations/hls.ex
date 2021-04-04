defmodule SuumWeb.Api.Mutations.Hls do
  use Absinthe.Schema.Notation
  alias SuumWeb.Api.{Resolvers, Middleware}

  input_object :transmission_input do
    field :name, :string
  end

  object :hls_mutations do
    @desc "Create Transmission"

    field :create_transmission, :transmission do
      # TODO: Move this below to a input instead of args
      arg(:name, non_null(:string))
      arg(:type, non_null(:string))

      middleware(Middleware.Authenticate)
      resolve(&Resolvers.Hls.create_transmission/3)
    end

    field :update_transmission, :transmission do
      arg(:uuid, non_null(:id))
      arg(:params, non_null(:transmission_input))

      middleware(Middleware.Authenticate)
      resolve(&Resolvers.Hls.update_transmission/3)
    end
  end
end
