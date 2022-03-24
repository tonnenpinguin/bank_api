defmodule BankAPIWeb.AccountControllerTest do
  use BankAPIWeb.ConnCase

  @create_attrs %{
    initial_balance: 42_00
  }
  @invalid_attrs %{
    initial_balance: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      response =
        conn
        |> post(Routes.account_path(conn, :create), account: @create_attrs)
        |> json_response(201)

      assert %{
               "uuid" => _uuid,
               "current_balance" => 4200
             } = response["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      response =
        conn
        |> post(Routes.account_path(conn, :create), account: @invalid_attrs)
        |> json_response(422)

      assert response["errors"] != %{}
    end
  end
end
