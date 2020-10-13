defmodule SuumWeb.Presence do
  use Phoenix.Presence,
    otp_app: :suum,
    pubsub_server: Suum.PubSub
end
