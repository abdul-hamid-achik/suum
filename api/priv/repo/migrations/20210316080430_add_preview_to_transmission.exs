defmodule Suum.Repo.Migrations.AddPreviewToTransmission do
  use Ecto.Migration

  def change do
    alter table(:transmissions) do
      add :preview, :string
    end
  end
end
