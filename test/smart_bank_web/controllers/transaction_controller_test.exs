
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
      conn = conn |> put_req_header("authorization", "Bearer #{Ecto.UUID.generate()}")
      conn = post(conn, Routes.v1_transaction_path(conn, :deposit), %{amount: 50_000})

      payload = json_response(conn, 401)
      assert payload |> Map.has_key?("errors")
    end
  end

  describe "withdraw" do
    test "withdraw amount", %{conn: conn, jwt_account_token: jwt_account_token} do
      conn = conn |> put_req_header("authorization", "Bearer #{jwt_account_token}")
      conn = post(conn, Routes.v1_transaction_path(conn, :deposit), %{amount: 50_000})
      conn = post(conn, Routes.v1_transaction_path(conn, :withdraw), %{amount: 40_000})

      payload = json_response(conn, 200)

      assert payload["type"] == "withdraw"
      assert payload |> Map.has_key?("account_id")
      assert payload |> Map.has_key?("transaction_id")
    end

    test "withdraw not work. Why? insuficient wallet",
         %{conn: conn, jwt_account_token: jwt_account_token} do
      conn = conn |> put_req_header("authorization", "Bearer #{jwt_account_token}")
      conn = post(conn, Routes.v1_transaction_path(conn, :deposit), %{amount: 30_000})
      conn = post(conn, Routes.v1_transaction_path(conn, :withdraw), %{amount: 40_000})

      payload = json_response(conn, 500)
      assert payload |> Map.has_key?("errors")
    end
  end

  describe "transfer" do
    test "transfer to another account", %{conn: conn, jwt_account_token: jwt_account_token} do
      conn = conn |> put_req_header("authorization", "Bearer #{jwt_account_token}")