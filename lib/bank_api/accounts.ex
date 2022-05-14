defmodule BankAPI.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias BankAPI.{App, Repo}

  alias BankAPI.Accounts.Commands.{
    OpenAccount,
    CloseAccount,
    DepositIntoAccount,
    WithdrawFromAccount
  }

  alias BankAPI.Accounts.Projections.Account

  defp get(module, id) do
    case Repo.get(module, id) do
      nil ->
        {:error, :not_found}

      result ->
        {:ok, result}
    end
  end

  def get_account(uuid), do: get(Account, uuid)

  def open_account(%{"initial_balance" => initial_balance}) do
    account_uuid = UUID.uuid4()

    dispatch_result =
      %OpenAccount{
        initial_balance: initial_balance,
        account_uuid: account_uuid
      }
      |> App.dispatch(consistency: :strong)

    with :ok <- dispatch_result do
      get_account(account_uuid)
    end
  end

  def open_account(_params), do: {:error, :bad_command}

  def close_account(account_uuid) do
    %CloseAccount{
      account_uuid: account_uuid
    }
    |> App.dispatch(consistency: :strong)
  end

  def deposit(account_uuid, amount) do
    dispatch_result =
      %DepositIntoAccount{
        account_uuid: account_uuid,
        deposit_amount: amount
      }
      |> Router.dispatch(consistency: :strong)

    with :ok <- dispatch_result do
      get_account(account_uuid)
    end
  end

  def withdraw(account_uuid, amount) do
    dispatch_result =
      %WithdrawFromAccount{
        account_uuid: account_uuid,
        withdraw_amount: amount
      }
      |> Router.dispatch(consistency: :strong)

    with :ok <- dispatch_result do
      get_account(account_uuid)
    end
  end
end
