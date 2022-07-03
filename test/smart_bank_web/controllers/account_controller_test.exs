defmodule SmartBankWeb.AccountControllerTest do
  use SmartBankWeb.ConnCase

  import SmartBank.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
    [jwt_account_token: jwt_account_token()]
  end

  describe "index" do
    test "lists all accounts without accounts created", %{
      conn: conn,
      jwt_account_token: jwt_account_token
    } do
      conn = conn |> put_req_header("authorization", "Bearer #{jwt_account_token}")
      conn = get(conn, Routes.v1_account_path(conn, :index))
      assert conn |> json_response(200) |> length() == 1
    end

    t