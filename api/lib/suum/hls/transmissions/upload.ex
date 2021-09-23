defmodule Suum.Hls.Transmissions.Upload do
  use Suum.Schema

  @required [
    :name,
    :uuid,
    :type
  ]

  @optional []

  embedded_schema do
    field :name, :string
    field :type, :string
    timestamps()
  end

  def changeset(state \\ %__MODULE__{}, attrs) do
    state
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end
