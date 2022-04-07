defmodule SmartBankWeb.V1.AccountView do
  use SmartBankWeb, :view

  alias SmartBankWeb.V1.AccountView

  def render("index.json", %{accounts: accounts}) do
    render_many(accounts, AccountView, "account.json")
  end

  def render("show.json", %{account: account}) do
    render_one