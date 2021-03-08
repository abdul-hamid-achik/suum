defmodule Suum.Hls.Thumbnails do
  alias Suum.Repo
  alias Suum.Hls.Thumbnail
  require Crudry.Context

  Crudry.Context.generate_functions(Thumbnail)
end
