defmodule BankAPIWeb.AccountControllerTest do
  use BankAPIWeb.ConnCase

  @create_attrs %{
    initial_balance: 420
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
               "current_balance" => 420
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

  describe "delete account" do
    test "returns 200 when data is valid", %{conn: conn} do
      %{uuid: account_uuid} = create_account!()

      response =
        conn
        |> delete(Routes.account_path(conn, :delete, account_uuid))

      assert response.status == 200
    end
  end

  describe "show account" do
    test "renders account when data is valid", %{conn: conn} do
      %{uuid: account_uuid} = create_account!()

      response =
        conn
        |> get(Routes.account_path(conn, :show, account_uuid))
        |> json_response(200)

      assert %{
               "uuid" => _uuid,
               "current_balance" => 420
             } = response["data"]
    end
  end

  defp create_account! do
    {:ok, account} = BankAPI.Accounts.open_account(%{"initial_balance" => 420})
    account
  end
end
