defmodule SmartBankWeb.V1.TransactionController do
  use SmartBankWeb, :controller

  alias SmartBank.Bank

  action_fallback SmartBankWeb.FallbackController

  def deposit(conn, %{"amount" => amount}) do
    account = conn.assigns.current_user.account

    with {:ok, account, transaction} <- account |> Bank.deposit(amount) do
      conn
      |> send_transaction_response("deposit", transaction, account)
    end
  end

  def deposit(_, _), do: {:error, "Invalid amount", 442}

  def withdraw(conn, %{"amount" => amount}) do
    account = conn.assigns.current_user.account

    with {:ok, account, transaction} <- account |> Bank.withdraw(amount) do
      conn
      |> send_transaction_response("withdraw", transaction, account)
    end
  end

  def transfer(conn, %{"amount" => amount, "account_id" => account_b_id}) do
    account_a = conn.assigns.current_user.account

    with {:ok, account_b} <- account_b_id |> Bank.get_account(),
         {:ok, %{transaction_a: t_a, transaction_b: t_b}} <-
           account_a |> Bank.transfer(account_b, amount) do
      conn
      |> render("transfer.json", type: "transfer", transaction_a: t_a, transaction_b: t_b)
    end
  end

  def report(conn, _params) do
    transactions = Bank.report()

    with true <- !(transactions.today |> is_nil),
         true <- !(transactions.month |> is_nil),
         true <- !(transactions.year |> is_nil) do
      conn
      |> render("report_transaction.json", transactions: transactions)
    end
  end

  def wallet(conn, %{"account_id" => account_id}) do
    us