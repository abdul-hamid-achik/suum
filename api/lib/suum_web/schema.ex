defmodule SuumWeb.Schema do
  use Absinthe.Schema

  alias SuumWeb.{Api.Types, Api.Queries}
  import_types(Queries.Hls)

  import_types(Absinthe.Type.Custom)
  import_types(Types.Segment)
  import_types(Types.Thumbnail)
  import_types(Types.Transmission)
  import_types(Types.User)

  query do
    import_fields(:hls_queries)
  end

  # mutation do
  # Add mutations here. Example
  # import_fields(:create_transmission)
  # end
end
