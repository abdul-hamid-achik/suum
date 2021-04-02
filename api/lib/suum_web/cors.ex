defmodule SuumWeb.CORS do
  use Corsica.Router,
    origins: "*",
    max_age: 600,
    allow_credentials: true,
    allow_methods: :all,
    allow_headers: :all,
    log: [rejected: :error]

  resource("/api", origins: "*")
  resource("/uploads", origins: "*")
end
