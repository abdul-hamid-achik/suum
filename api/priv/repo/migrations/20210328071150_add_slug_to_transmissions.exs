
defmodule Suum.Repo.Migrations.AddSlugToTransmissions do
  use Ecto.Migration

  def change do
    alter table(:transmissions) do
      add :slug, :string
    end

    create(unique_index(:transmissions, [:slug]))
  end
end
