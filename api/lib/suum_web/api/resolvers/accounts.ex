defmodule SuumWeb.Api.Resolvers.Accounts do
  require Crudry.Resolver
  alias Suum.{Accounts, Accounts.User}

  Crudry.Resolver.generate_functions(Accounts, User)
end
