defmodule SuumWeb.Schema do
  use Absinthe.Schema

  alias SuumWeb.Api
  alias Suum.{Hls, Accounts}
  import_types(Api.Queries.Hls)
  import_types(Api.Queries.Account)
  import_types(Api.Mutations.Account)
  import_types(Api.Mutations.Hls)

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
    import_fields(:hls_mutations)
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Accounts, Accounts.data())
      |> Dataloader.add_source(Hls, Hls.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
