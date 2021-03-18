defmodule SuumWeb.Schema do
  use Absinthe.Schema

  alias SuumWeb.Api
  import_types(Api.Queries.Hls)
  import_types(Api.Queries.Account)
  import_types(Api.Mutations.Account)

  import_types(Absinthe.Type.Custom)
  import_types(Api.Types.Segment)
  import_types(Api.Types.Thumbnail)
  import_types(Api.Types.Transmission)
  import_types(Api.Types.Session)
  import_types(Api.Types.User)

  query do
    import_fields(:account_queries)
    import_fields(:hls_queries)
  end

  mutation do
    import_fields(:account_mutations)
  end
end
