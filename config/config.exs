# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :suum,
  ecto_repos: [Suum.Repo]

# Configures the endpoint
config :suum, SuumWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "s1qI8gERo63luftli8DVLyC6IwmgsfIEDXdD0w7AhidJCStyaVZmurLzsVkst0O+",
  render_errors: [view: SuumWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Suum.PubSub,
  live_view: [signing_salt: "t9U8gjtP"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :suum, :pow,
  user: Suum.Users.User,
  repo: Suum.Repo,
  web_module: SuumWeb

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
