defmodule Suum.Repo do
  use Ecto.Repo,
    otp_app: :suum,
    adapter: Ecto.Adapters.Postgres
end
