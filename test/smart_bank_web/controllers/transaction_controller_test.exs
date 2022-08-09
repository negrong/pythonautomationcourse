
defmodule SmartBankWeb.TransactionControllerTest do
  use SmartBankWeb.ConnCase

  import SmartBank.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
    [jwt_account_token: jwt_account_token()]
  end

  describe "deposit" do
    test "deposit amount", %{conn: conn, jwt_account_token: jwt_account_token} do
      conn = conn |> put_req_header("authorization", "Bearer #{jwt_account_token}")
      conn = post(conn, Routes.v1_transaction_path(conn, :deposit), %{amount: 50_000})

      payload = json_response(conn, 200)

      assert payload["type"] == "deposit"
      assert payload |> Map.has_key?("account_id")
      assert payload |> Map.has_key?("transaction_id")
    end

    test "no deposit amount, why? not pass amount on payload", %{
      conn: conn,
      jwt_account_token: jwt_account_token
    } do
      conn = conn |> put_req_header("authorization", "Bearer #{jwt_account_token}")
      conn = post(conn, Routes.v1_transaction_path(conn, :deposit), %{})

      payload = json_response(conn, 442)
      assert payload |> Map.has_key?("errors")
    end

    test "no deposit amount, why? unauthenticated user", %{conn: conn} do