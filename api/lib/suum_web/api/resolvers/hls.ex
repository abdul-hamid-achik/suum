defmodule SuumWeb.Api.Resolvers.Hls do
  alias Suum.Repo
  alias Suum.Hls.{Tranmissions, Segments}
  alias Suum.Hls.{Transmision, Segment}
  require Crudry.Resolver

  Crudry.Resolver.generate_functions(Tranmissions, Transmision)
  Crudry.Resolver.generate_functions(Segments, Segment)
end
