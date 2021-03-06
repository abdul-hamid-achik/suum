defmodule Suum.Schema do
  defmacro __using__(_) do
    quote do
      @primary_key {:id, Ecto.UUID, autogenerate: true}

      use Ecto.Schema
      import Ecto.Changeset
      import Crudry.Query
      import EctoEnum
    end
  end
end
