defmodule SuumWeb.Context do
  @behaviour Plug

  import Plug.Conn

  alias Suum.Accounts

  def init(opts), do: opts

  def call(conn, _) do
    case build_context(conn) do
      {:ok, context} ->
        put_private(conn, :absinthe, %{context: context})

      _ ->
        conn
    end
  end

  defp build_context(conn) do
    with ["Bearer " <> encoded_token] <- get_req_header(conn, "authorization"),
         #  {:ok, user, _claims} <- Suum.Guardian.resource_from_token(token)
         {:ok, token} <- Base.url_decode64(encoded_token, padding: false),
         user <- Accounts.get_user_by_session_token(token) do
      {:ok, %{current_user: user}}
    else
      error -> IO.inspect(error, label: "error ")
    end
  end
end
