defmodule SuumWeb.Api.Types.Segment do
  use Absinthe.Schema.Notation

  object :segment do
    field(:uuid, :id)
    field(:time_start, :naive_datetime)
    field(:time_end, :naive_datetime)
    field(:file, :string)
    field(:duration, :integer)
  end
end
