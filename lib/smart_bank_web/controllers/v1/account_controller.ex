defmodule SmartBankWeb.V1.AccountController do
  use SmartBankWeb, :controller

  alias SmartBank.Bank
  alias SmartBank.Bank.Account

  action_fallback SmartBankWeb.FallbackController

  def index(conn, _params) do
    accounts = Bank.list_account()
    render(conn, "index.json", accounts: accounts)
  end

  def cre