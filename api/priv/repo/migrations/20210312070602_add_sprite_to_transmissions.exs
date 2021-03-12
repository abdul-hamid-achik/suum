defmodule Suum.Repo.Migrations.AddSpriteToTransmissions do
  use Ecto.Migration

  def change do
    alter table(:transmissions) do
      add :sprite, :string
    end
  end
end
