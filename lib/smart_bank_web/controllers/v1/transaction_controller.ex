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
    account = conn.assigns.c