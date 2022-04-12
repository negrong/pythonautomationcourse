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
   