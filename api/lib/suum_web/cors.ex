defmodule SuumWeb.CORS do
  use Corsica.Router,
    origins: "*",
    max_age: 600,
    allow_credentials: true,
    allow_methods: :all,
    allow_headers: :all,
    expose_headers: ~W(Location Upload-Offset),
    log: [rejected: :error, invalid: :warn, accepted: :info]

  resource("/api", origins: "*")
  resource("/upload/*", origins: "*")
  resource("/transmissions/*", origins: "*")
end
