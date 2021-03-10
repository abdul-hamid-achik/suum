defmodule SuumWeb.Api.Types.Thumbnail do
  use Absinthe.Schema.Notation

  object :thumbnail do
    field(:uuid, :id)
    field(:transmission, :transmission)
    field(:transmission_uuid, :id)
    field(:url, :string)
  end
end
