defmodule SuumWeb.Api.Resolvers.Accounts do
  alias Suum.{Accounts, Accounts.User}
  require Crudry.Resolver

  Crudry.Resolver.generate_functions(Accounts, User)
end
