defmodule Suum.Repo do
  use Ecto.Repo,
    otp_app: :suum,
    adapter: Ecto.Adapters.Postgres

  def init(_, config) do
    config =
      config
      |> Keyword.put(
        :username,
        System.get_env(
          "PGUSER",
          Application.get_env(:suum, :username, "postgres")
        )
      )
      |> Keyword.put(
        :password,
        System.get_env(
          "PGPASSWORD",
          Application.get_env(:suum, :password, "postgres")
        )
      )
      |> Keyword.put(
        :database,
        System.get_env(
          "PGDATABASE",
          Application.get_env(:suum, :database, "suum_dev")
        )
      )
      |> Keyword.put(
        :hostname,
        System.get_env(
          "PGHOST",
          Application.get_env(:suum, :hostname, "localhost")
        )
      )
      |> Keyword.put(
        :port,
        System.get_env(
          "PGPORT",
          Application.get_env(:suum, :port, "5432")
        )
        |> String.to_integer()
      )

    {:ok, config}
  end
end
