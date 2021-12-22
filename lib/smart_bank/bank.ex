
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

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Create user and add account.

  ## Examples

      iex> list_account()
      [%Account{}, ...]

  """
  @spec signup(:invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}) :: any
  def signup(signup_attrs) do
    with {:ok, user} <- signup_attrs |> Authentication.create_user(),
         {:ok, account} <- signup_attrs |> Map.merge(%{"user_id" => user.id}) |> create_account(),
         {:ok, _} <- %{account_id: account.id} |> create_wallet() do
      {:ok, account, _} = account |> deposit(@inital_deposit_amount)
      {:ok, account}
    end
  end

  @doc """