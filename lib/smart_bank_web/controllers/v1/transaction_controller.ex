defmodule SmartBankWeb.V1.TransactionController do
  use SmartBankWeb, :controller

  alias SmartBank.Bank

  action_fallback Smart