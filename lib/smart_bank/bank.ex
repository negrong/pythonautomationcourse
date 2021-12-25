
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
    attrs = attrs |> Map.merge(%{amount: 0})

    %Wallet{}
    |> Wallet.changeset(attrs)
    |> Repo.insert()
  end

  defp validate_wallet_change(%Wallet{} = wallet, amount) do
    wallet.amount
    |> Money.add(amount)
    |> Money.positive?()
  end

  defp update_wallet(%Wallet{} = wallet, amount) do
    if wallet |> validate_wallet_change(amount) do
      new_amount = wallet.amount |> Money.add(amount)

      wallet
      |> Wallet.changeset(%{amount: new_amount})
      |> Repo.update()
    else
      {:error, "Invalid changes on wallet", 500}
    end
  end

  @doc """
  Create transaction withdraw to given account.

  ## Examples

      iex> account |> withdraw(Money.new(1000))
      {:ok, %Account{}, %Transaction{}}

  """
  @spec withdraw(SmartBank.Bank.Account.t(), any) :: nil
  def withdraw(%Account{id: account_id} = account, %Money{} = amount) do
    amount =
      amount
      |> Money.abs()
      |> Money.neg()

    transaction_attrs = %{account_id: account_id, amount: amount}

    with {:ok, transaction} <- transaction_attrs |> create_transaction(),
         %Wallet{} = wallet <- account_id |> get_wallet(),
         {:ok, _} <- wallet |> update_wallet(transaction.amount) do
      account =
        account
        |> Repo.preload(:wallet, force: true)
        |> Repo.preload(:user, force: true)

      Task.async(fn -> send_withdraw_mail(account, transaction) end)
      {:ok, account, transaction}
    end
  end

  def withdraw(%Account{} = account, amount) when is_integer(amount) do
    account |> withdraw(amount |> Money.new())
  end

  def withdraw(_, _), do: {:error, "Invalid Account"}

  @doc """
  Send message to console about the transaction

    ## Examples

      iex> %Account{} |> send_withdraw_mail(%Transaction{})
      "Money withdraw accomplished!"
      "from: transaction@smart-bank.com, to: email"
      "Withdraw of amount"
  """
  def send_withdraw_mail(%Account{} = account, %Transaction{} = transaction) do
    IO.puts("Money withdraw accomplished!")
    IO.puts("from: transaction@smart-bank.com, to: #{account.user.email}")
    IO.puts("Withdraw of #{transaction.amount}")
  end

  @doc """
  Transfer money between accounts

    ## Examples

      iex> %Account{} |> transfer(%Account{}, Integer.t() | Money.t())
      %{transaction_a: Map.t(), transaction_b: Map.t()}
  """
  @spec transfer(SmartBank.Bank.Account.t(), SmartBank.Bank.Account.t(), integer | Money.t()) :: any
  def transfer(%Account{id: account_a_id}, %Account{id: account_b_id}, %Money{} = amount) do
    amount_a =
      amount
      |> Money.abs()
      |> Money.neg()

    amount_b =
      amount
      |> Money.abs()

    transaction_a_attrs = %{account_id: account_a_id, amount: amount_a}
    transaction_b_attrs = %{account_id: account_b_id, amount: amount_b}