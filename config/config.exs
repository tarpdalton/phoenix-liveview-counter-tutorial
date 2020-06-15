# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :live_view_counter, LiveViewCounterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "K73oqZVIRIAck+a4sNK0V/hPujAYLeXGrKwax57JXFKMb8z64kgTaMF0Ys/Ikhrm",
  render_errors: [view: LiveViewCounterWeb.ErrorView, accepts: ~w(html json)],
  # pubsub: [name: LiveViewCounter.PubSub, adapter: Phoenix.PubSub.PG2],
  pubsub_server: LiveViewCounter.PubSub,
  live_view: [signing_salt: "Eh8C9qeyMysWOpDBw+3YcPsGi116KXPM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
