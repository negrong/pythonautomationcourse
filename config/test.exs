use Mix.Config

# Configure your database
config :SmartBank, SmartBank.Repo,
  username: 'dev',
  password: 'dev123',
  database: 'smart_bank_test',
  hostname: 'localhost',
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :SmartBank, SmartBankWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings a