defmodule SuumWeb.Schema do
  use Absinthe.Schema

  alias SuumWeb.Schema
  alias SuumWeb.Api.Types

  import_types(Absinthe.Type.Custom)
  import_types(Types.Segment)
  import_types(Types.Transmission)
  import_types(Types.User)

  query do
    # import_fields(:get_segments)
    # import_fields(:get_transmissions)
    # import_fields(:user_queries)
  end

  mutation do
    # Add mutations here. Example
    # import_fields(:create_product)
  end
end
