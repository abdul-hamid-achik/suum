defmodule SuumWeb.Api.Types.Thumbnail do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias Suum.Hls

  object :thumbnail do
    field(:uuid, :id)
    field(:transmission, :transmission, resolve: dataloader(Hls))
    field(:url, :string)
  end
end
