defmodule Suum.Hls.Transmissions do
  alias Suum.Repo
  alias Suum.Hls.Transmission
  require Crudry.Context

  Crudry.Context.generate_functions(Transmission)
end
