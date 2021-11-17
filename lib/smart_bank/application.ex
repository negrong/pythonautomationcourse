defmodule SmartBank.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      SmartBank.Repo,
      # Start the endpoint when the application starts
      SmartBankWeb.Endpoint
      # Starts a worker by calling: SmartBank.Worker.start_link(arg)
      # {SmartBank.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sma