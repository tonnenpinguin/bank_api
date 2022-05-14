defmodule BankAPI.Aggregates.AccountTest do
  use BankAPI.Test.InMemoryEventStoreCase

  alias BankAPI.Accounts.Aggregates.Account, as: Aggregate
  alias BankAPI.Accounts.Events.{AccountOpened, AccountClosed}
  alias BankAPI.Accounts.Commands.{OpenAccount, CloseAccount}

  test "ensure agregate gets correct state on creation" do
    uuid = UUID.uuid4()

    account =
      %Aggregate{}
      |> evolve(%AccountOpened{
        initial_balance: 1_000,
        account_uuid: uuid
      })

    assert account.uuid == uuid
    assert account.current_balance == 1_000
  end

  test "errors out on invalid opening balance" do
    invalid_command = %OpenAccount{
      initial_balance: -1_000,
      account_uuid: UUID.uuid4()
    }

    assert {:error, :initial_balance_must_be_above_zero} =
             Aggregate.execute(%Aggregate{}, invalid_command)
  end

  test "errors out on already opened account" do
    uuid = UUID.uuid4()

    command = %OpenAccount{
      initial_balance: 1_000,
      account_uuid: uuid
    }

    assert {:error, :account_already_opened} = Aggregate.execute(%Aggregate{uuid: uuid}, command)
  end

  test "closing an open account works" do
    uuid = UUID.uuid4()

    account =
      %Aggregate{current_balance: 1_000, uuid: uuid, closed?: false}
      |> evolve(%AccountClosed{account_uuid: uuid})

    assert account.closed? == true
  end

  test "closing a closed account fails" do
    uuid = UUID.uuid4()

    command = %CloseAccount{
      account_uuid: uuid
    }

    assert {:error, :account_already_closed} =
             %Aggregate{uuid: uuid, closed?: true}
             |> Aggregate.execute(command)
  end
end
