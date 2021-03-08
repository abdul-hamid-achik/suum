defmodule Suum.Repo.Migrations.CreateThumbnailTable do
  use Ecto.Migration

  def change do
    create table(:thumbnails, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :file, :string
      add :timestamp, :utc_datetime
      add :transmission_uuid, references(:transmissions, type: :uuid, column: :uuid)
      timestamps()
    end
  end
end
