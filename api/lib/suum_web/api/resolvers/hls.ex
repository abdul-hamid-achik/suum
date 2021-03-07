defmodule SuumWeb.Api.Resolvers.Hls do
  alias Suum.Hls.{Tranmissions, Segments}
  alias Suum.Hls.{Transmission, Segment}
  require Crudry.Resolver

  Crudry.Resolver.generate_functions(Tranmissions, Transmission)
  Crudry.Resolver.generate_functions(Segments, Segment)
end
