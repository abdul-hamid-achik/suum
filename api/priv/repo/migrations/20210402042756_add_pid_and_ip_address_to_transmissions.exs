defmodule Suum.Repo.Migrations.AddPidAndIpAddressToTransmissions do
  use Ecto.Migration

  def change do
    alter table(:transmissions) do
      add :pid, :string
      add :ip_address, :string
    end
  end
end
