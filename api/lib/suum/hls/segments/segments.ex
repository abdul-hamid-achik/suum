defmodule Suum.Hls.Segments do
  alias Suum.Hls.Segment
  require Crudry.Context

  Crudry.Context.generate_functions(Segment)
end
