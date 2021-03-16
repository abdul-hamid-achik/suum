defmodule SuumWeb.Api.Types.Transmission do
  use Absinthe.Schema.Notation

  object :transmission do
    field(:uuid, :id)
    field(:user, :user)
    field(:name, :string)
    field(:type, :string)
    field(:segments, list_of(:segment))
    field(:sprite, :string)
    field(:sprite_url, :string)

    field :preview, :string do
      resolve(fn
        %{preview: nil}, _, _ ->
          {:ok, Faker.Avatar.image_url()}

        %{preview: preview}, _, _ ->
          IO.inspect(preview)
          {:ok, preview}
      end)
    end

    field(:preview_url, :string)
  end
end
