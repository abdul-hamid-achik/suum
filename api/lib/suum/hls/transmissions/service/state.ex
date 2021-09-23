defmodule Suum.Hls.Transmissions.Service.State do
  use Suum.Schema

  alias Suum.Hls.{Tranmsissions.Upload, Transmissions.Service.Machine}

  @required [
    :transmission,
    :ip_address,
    :token
  ]

  @optional [
    :status,
    :upload,
    :segments
  ]

  embedded_schema do
    embeds_one(:transmission, Transmission)
    embeds_one(:upload, Upload)
    field :segments, {:array, :map}
    field :status, :string, default: "created"
    field :token, :string
    field :ip_address, :string

    timestamps()
  end

  def changeset(state \\ %__MODULE__{}, attrs) do
    state
    |> cast(attrs, @required ++ @optional)
    |> cast_embed(:transmission)
    |> validate_required(@required)
    |> validate_segments_unique()
  end

  def upsert_segments(state, segments) do
    state
    |> put_change(:segments, segments)
    |> apply_action(:insert)
  end

  @spec transition_to(t(), State.t()) :: {:ok, t()} | {:error, String.t()}
  def transition_to(state, next_status) do
    with %Ecto.Changeset{valid?: true} <- State.changeset(state, %{status: next_status}),
         {:ok, updated_state} <-
           Machinery.transition_to(state, Machine, next_status) do
      updated_state
    end
  end

  defp validate_segments_unique(changeset) do
    segments = fetch_field(changeset, :segments)
    new_segments = fetch_change(changeset, :segments)

    Enum.reduce(new_segments, fn segment, acc_changeset ->
      case Enum.member?(segments, segment) do
        true -> add_error(acc_changeset, :segments, "Duplicated Segment")
        false -> acc_changeset
      end
    end)
  end
end
