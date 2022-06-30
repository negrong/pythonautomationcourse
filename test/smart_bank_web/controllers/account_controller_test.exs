defmodule SmartBankWeb.AccountControllerTest do
  use SmartBankWeb.ConnCase

  import SmartBank.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
    [jwt_account_token: jwt_account_token(