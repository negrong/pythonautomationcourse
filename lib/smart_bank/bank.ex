
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
  Create transaction deposit to given account.

  ## Examples

      iex> account |> deposit(Money.new(1000))
      {:ok, %Account{}, %Transaction{}}

  """
  @spec deposit(SmartBank.Bank.Account.t(), any) :: nil
  def deposit(%Account{id: account_id} = account, %Money{} = amount) do
    transaction_attrs = %{account_id: account_id, amount: amount}

    with {:ok, transaction} <- transaction_attrs |> create_transaction(),
         %Wallet{} = wallet <- account_id |> get_wallet(),
         {:ok, _} <- wallet |> update_wallet(transaction.amount) do
      account =
        account
        |> Repo.preload(:wallet, force: true)
        |> Repo.preload(:user, force: true)

      {:ok, account, transaction}
    end
  end

  def deposit(%Account{} = account, amount) when is_integer(amount) do
    account
    |> deposit(amount |> Money.new())
  end

  def deposit(_, _), do: {:error, "Operation failed, this account is not valid"}


  @doc """
  Create unique transaction.

  ## Examples

      iex> %{account_id: "uuid", amount: 1000} |> create_transaction()
      {:ok, %Transaction{}}

  """
  @spec create_transaction(
          :invalid
          | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: any
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end


  @doc """
  Return wallet by account id.

  ## Examples

      iex> account_id |> get_wallet()
      {:ok, %Wallet{}}

  """
  @spec get_wallet(any) :: any
  def get_wallet(account_id) do
    Wallet
    |> Repo.get_by(account_id: account_id)
  end

  defp create_wallet(attrs) do