defmodule SuumWeb.CORS do
  use Corsica.Router,
    origins: ["http://localhost", ~r{^https?://(.*\.)?suum\.io$}],
    allow_credentials: true,
    max_age: 600

  resource("/api", origins: "*")
  # resource("/*")
end
