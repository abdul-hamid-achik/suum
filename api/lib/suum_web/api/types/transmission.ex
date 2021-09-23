defmodule SuumWeb.Api.Types.Transmission do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias Suum.{Accounts, Hls}

  object :transmission do
    field(:uuid, :id)
    field(:user, :user, resolve: dataloader(Accounts))

    field(:name, :string)
    field(:slug, :string)
    field(:type, :string)
    field(:ip_address, :string)
    field(:pid, :string)
    field(:state, :string)
    field(:segments, list_of(:segment), resolve: dataloader(Hls))
    field(:sprite, :string)
    field(:presigned_sprite_url, :string)

    field :preview, :string do
      resolve(fn
        %{presigned_preview_url: nil}, _, _ ->
          {:ok, Faker.Avatar.image_url()}

        %{presigned_preview_url: presigned_preview_url}, _, _ ->
          {:ok, presigned_preview_url}
      end)
    end

    field(:presigned_preview_url, :string)
  end
end
