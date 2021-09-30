use Mix.Config

# Configure your database
config :SmartBank, SmartBank.Repo,
  username: 'dev',
  password: 'dev123',
  database: 'smart_bank_test',
  ho