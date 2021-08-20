
# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :SmartBank,
  ecto_repos: [SmartBank.Repo]

# Configures the endpoint
config :SmartBank, SmartBankWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Z6hWNrE3OE+tWJtiHbvkFPnBUpMl4A1cz5T5fDJS4cmVlvY7Ta1Ii1OgHJVmE2cY",
  render_errors: [view: SmartBankWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: SmartBank.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :SmartBank, SmartBank.Authentication.Guardian,