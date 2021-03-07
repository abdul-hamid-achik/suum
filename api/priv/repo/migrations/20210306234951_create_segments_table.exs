defmodule Suum.Repo.Migrations.CreateSegmentsTable do
  use Ecto.Migration

  def change do
    create table(:segments, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :file, :string
      add :time_start, :utc_datetime
      add :time_end, :utc_datetime
      add :duration, :integer

      add :transmission_uuid, references(:transmissions, type: :uuid, column: :uuid)
      timestamps()
    end
  end
end
