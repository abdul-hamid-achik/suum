defmodule SuumWeb.Api.Types.Segment do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias Suum.Hls

  object :segment do
    field(:uuid, :id)
    field(:time_start, :naive_datetime)
    field(:time_end, :naive_datetime)
    field(:transmission, :transmission, resolve: dataloader(Hls))
    field(:file, :string)
    field(:duration, :integer)
  end
end
