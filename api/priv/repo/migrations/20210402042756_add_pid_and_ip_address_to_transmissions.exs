defmodule Suum.Repo.Migrations.AddPidAndIpAddressToTransmissions do
  use Ecto.Migration

  def change do
    alter table(:transmissions) do
      add :pid, :integer
      add :ip_address, :string
    end
  end
end
