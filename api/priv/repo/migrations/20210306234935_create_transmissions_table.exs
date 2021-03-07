defmodule Suum.Repo.Migrations.CreateTransmissionsTable do
  use Ecto.Migration

  def change do
    create table(:transmissions, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :name, :string
      add :type, :string
      add :user_uuid, references(:users, type: :uuid, column: :uuid)
      timestamps()
    end
  end
end
