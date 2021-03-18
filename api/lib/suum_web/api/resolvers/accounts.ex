defmodule SuumWeb.Api.Resolvers.Accounts do
  require Crudry.Resolver
  alias Suum.{Accounts, Accounts.User, Accounts.User}
  alias SuumWeb.ChangesetErrors

  Crudry.Resolver.generate_functions(Accounts, User)

  def signin(_, %{email: email, password: password}, _) do
    if user = Accounts.get_user_by_email_and_password(email, password) do
      token = create_token_for_user(user)
      {:ok, %{user: user, token: token}}
    else
      {:error, "Whoops, invalid credentials!"}
    end
  end

  def signup(_, args, _) do
    case Accounts.register_user(args) do
      {:error, changeset} ->
        {
          :error,
          message: "Could not create account", details: ChangesetErrors.error_details(changeset)
        }

      {:ok, user} ->
        token = create_token_for_user(user)

        {:ok, %{user: user, token: token}}
    end
  end

  def me(_, _, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def me(_, _, _) do
    {:ok, nil}
  end

  defp create_token_for_user(user) do
    user
    |> Accounts.generate_user_session_token()
    |> Base.url_encode64()
  end
end
