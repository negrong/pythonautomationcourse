defmodule SmartBankWeb.V1.TransactionView do
  use SmartBankWeb, :view

  alias SmartBankWeb.V1.TransactionView

  def render("transaction.json", %{transaction: transact