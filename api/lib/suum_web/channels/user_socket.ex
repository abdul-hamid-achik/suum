defmodule SuumWeb.UserSocket do
  use Phoenix.Socket
  alias Suum.Accounts
  require Logger

  channel("transmit:*", SuumWeb.TransmitChannel)

  @impl true
  def connect(%{"token" => encoded_token}, socket, _connect_info) do
    with {:ok, token} <- Base.url_decode64(encoded_token, padding: false),
         user <- Accounts.get_user_by_session_token(token) do
      {:ok, assign(socket, :current_user, user)}
    else
      error ->
        Logger.error(inspect(error, pretty: true))
        {:error, socket}
    end
  end

  @impl true
  def id(_socket), do: nil
end
