
use Mix.Config

# Configure your database
config :SmartBank, SmartBank.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("PGUSER"),
  password: System.get_env("PGPASSWORD"),
  database: System.get_env("PGDATABASE"),
  hostname: System.get_env("PGHOST"),
  show_sensitive_data_on_connection_error: true,
  pool_size: 10


  # adapter: Ecto.Adapters.Postgres,
  # username: System.get_env("PGUSER"),
  # password: System.get_env("PGPASSWORD"),
  # database: System.get_env("PGDATABASE"),
  # hostname: System.get_env("PGHOST"),

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external