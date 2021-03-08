defmodule SuumWeb.Api.Resolvers.Hls do
  alias Suum.Hls.{Transmissions, Segments}
  alias Suum.Hls.{Transmission, Segment}
  require Crudry.Resolver

  Crudry.Resolver.generate_functions(Transmissions, Transmission)
  Crudry.Resolver.generate_functions(Segments, Segment)
end
