defmodule SuumWeb.Api.Resolvers.Hls do
  require Crudry.Resolver
  alias Suum.Hls.{Transmissions, Segments, Thumbnails}
  alias Suum.Hls.{Transmission, Segment, Thumbnail}

  Crudry.Resolver.generate_functions(Transmissions, Transmission)
  Crudry.Resolver.generate_functions(Segments, Segment)
  Crudry.Resolver.generate_functions(Thumbnails, Thumbnail)
end
