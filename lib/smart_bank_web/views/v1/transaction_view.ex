defmodule SmartBankWeb.V1.TransactionView do
  use SmartBankWeb, :view

  alias SmartBankWeb.V1.TransactionView

  def render("transaction.json", %{transaction: transaction}) do
    if transaction |> Map.has_key?(:type) do
      transaction_detail(
        transaction.account_id,
        transaction.amount,
        transaction.date,
        transaction.transaction_id,
        transaction.type
      )
    else
      transaction_detail(
        transaction.account_id,
        transaction.amount,
        transaction.date,
        transaction.transaction_id
      )
    end
  end

  def render("transfer.json", %{type: type, transaction_a: t_a, transaction_b: t_b}) do
    %{
      transactions: [
        render_one(t_a |> Map.put(:type, type), TransactionView, "transaction.json"),
        render_one(t_b |> Map.put(:type, type), TransactionView, "transaction.json")
      ]
    }
  end

  def render("report_transaction.json", %{transactions: transactions}) do
    %{
      today: render_many(transactions.today, TransactionView, "transaction.json"),
      month: transactions.month |> handle_groups(),
      year: transactions.year |> handle_groups()
    }
  end

  def render("wallet.json", %{wallet: wallet, account_id: account_id}) do
    %{
      wallet: wallet |> Money.to_string(),
      account_i