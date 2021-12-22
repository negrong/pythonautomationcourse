
defmodule SmartBank.Bank do
  @moduledoc """
  Bank context.
  """

  import Ecto.Query, warn: false
  alias SmartBank.Authentication
  alias SmartBank.Repo
  alias SmartBank.Bank.{
    Account,
    Wallet,
    Report, 