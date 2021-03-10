defmodule SuumWeb.Api.Types.Thumbnail do
  use Absinthe.Schema.Notation

  object :thumbnail do
    field(:uuid, :id)
    field(:transmission, :transmission)
    field(:transmission_uuid, :id)
    field(:file_url, :string)
  end
end
