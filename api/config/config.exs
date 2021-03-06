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
  secret_key_base: "Krj5HpQToTdm/InnItlYF+K8qO9kdwmMotLFG0/9rpzd/EUn9AqqPlyX7BQ945Um",
  render_errors: [view: SuumWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Suum.PubSub,
  live_view: [signing_salt: "OHdMvegK"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :suum, Suum.Guardian,
  issuer: "suum",
  secret_key: "2m9Vl9d1P/XiaRc8mSvhwB3GzYXmRkxLWyt+bUIoafypZTG+JDTJmkM2F1zG9OHX9Rs=",
  ttl: {3, :days}

config :suum, SuumWeb.AuthAccessPipeline,
  module: Suum.Guardian,
  error_handler: SuumWeb.AuthErrorHandler

config :waffle,
  storage: Waffle.Storage.S3, # or Waffle.Storage.Local
  bucket: System.get_env("AWS_BUCKET_NAME") # if using S3

# If using S3:
config :ex_aws,
  json_codec: Jason,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION")

config :suum, Suum.Mailer,
  adapter: Bamboo.MandrillAdapter,
  api_key: "my_api_key"

config :kaffy,
   otp_app: :suum,
   ecto_repo: Suum.Repo,
   router: SuumWeb.Router

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
