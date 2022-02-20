defmodule SmartBankWeb.V1.AuthenticationController do
  use SmartBankWeb, :controller

  alias SmartBank.Authentication

  action_fallback SmartBankWeb.Fallb