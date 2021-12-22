
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
    Transaction,
  }

  @inital_deposit_amount Money.new(100_000)

  @doc """
  Returns list of account.

  ## Examples

      iex> list_account()
      [%Account{}, ...]

  """
  def list_account do
    Report.list_accounts_preloaded()
    |> Repo.all()
  end

  @doc """
  Returns list of account.

  ## Examples

      iex> get_account(account_id)
      %Account{}

  """
  def get_account(account_id) do
    Account
    |> Repo.get(account_id)
    |> Repo.preload(:wallet)
    |> format_response()
  end

  defp format_response(%Account{} = account), do: {:ok, account}
  defp format_response(_), do: {:error, "Account not found", 404}

  @doc """
  Creates account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}