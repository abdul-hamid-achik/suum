defmodule SuumWeb.Api.Queries.Hls do
  use Absinthe.Schema.Notation
  alias SuumWeb.Api.Resolvers

  object :hls_queries do
    @desc "Get all transmissions"
    field :transmissions, list_of(:transmission) do
      resolve(&Resolvers.Hls.list_transmissions/2)
    end

    @desc "Get transmission"
    field :transmission, :transmission do
      arg(:uuid, non_null(:id))
      resolve(&Resolvers.Hls.get_transmission/2)
    end

    @desc "Get all thumbnails"
    field :thumbnails, list_of(:thumbnail) do
      arg(:transmission_uuid, :id)
      resolve(&Resolvers.Hls.list_thumbnails/2)
    end

    @desc "Get thumbnail"
    field :thumbnail, :thumbnail do
      arg(:uuid, non_null(:id))
      resolve(&Resolvers.Hls.get_thumbnail/2)
    end
  end
end
