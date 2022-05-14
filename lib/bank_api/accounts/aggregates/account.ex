defmodule BankAPI.Accounts.Aggregates.Account do
  defstruct [:uuid, :current_balance, closed?: false]

  alias BankAPI.Accounts.Commands.{
    OpenAccount,
    CloseAccount,
    DepositIntoAccount,
    WithdrawFromAccount
  }

  alias BankAPI.Accounts.Events.{
    AccountOpened,
    AccountClosed,
    DepositedIntoAccount,
    WithdrawnFromAccount
  }

  def execute(
        %__MODULE__{uuid: nil},
        %OpenAccount{
          initial_balance: initial_balance
        }
      )
      when initial_balance <= 0 do
    {:error, :initial_balance_must_be_above_zero}
  end

  def execute(
        %__MODULE__{uuid: nil},
        %OpenAccount{
          account_uuid: account_uuid,
          initial_balance: initial_balance
        }
      ) do
    %AccountOpened{
      account_uuid: account_uuid,
      initial_balance: initial_balance
    }
  end

  def execute(%__MODULE__{}, %OpenAccount{}) do
    {:error, :account_already_opened}
  end

  def execute(
        %__MODULE__{uuid: account_uuid, closed?: true},
        %CloseAccount{
          account_uuid: account_uuid
        }
      ) do
    {:error, :account_already_closed}
  end

  def execute(
        %__MODULE__{uuid: account_uuid, closed?: false},
        %CloseAccount{
          account_uuid: account_uuid
        }
      ) do
    %AccountClosed{
      account_uuid: account_uuid
    }
  end

  def execute(
        %__MODULE__{},
        %CloseAccount{}
      ) do
    {:error, :not_found}
  end

  def execute(
        %__MODULE__{uuid: account_uuid, closed?: true},
        %DepositIntoAccount{account_uuid: account_uuid}
      ) do
    {:error, :account_closed}
  end

  def execute(
        %__MODULE__{uuid: account_uuid, current_balance: current_balance},
        %DepositIntoAccount{account_uuid: account_uuid, deposit_amount: amount}
      ) do
    %DepositedIntoAccount{
      account_uuid: account_uuid,
      new_current_balance: current_balance + amount
    }
  end

  def execute(
        %__MODULE__{},
        %DepositIntoAccount{}
      ) do
    {:error, :not_found}
  end

  def execute(
        %__MODULE__{uuid: account_uuid, closed?: true},
        %WithdrawFromAccount{account_uuid: account_uuid}
      ) do
    {:error, :account_closed}
  end

  def execute(
        %__MODULE__{uuid: account_uuid, current_balance: current_balance},
        %WithdrawFromAccount{account_uuid: account_uuid, withdraw_amount: amount}
      ) do
    if current_balance - amount > 0 do
      %WithdrawnFromAccount{
        account_uuid: account_uuid,
        new_current_balance: current_balance - amount
      }
    else
      {:error, :insufficient_funds}
    end
  end

  def execute(
        %__MODULE__{},
        %WithdrawFromAccount{}
      ) do
    {:error, :not_found}
  end

  # state mutators
  def apply(
        %__MODULE__{} = account,
        %AccountOpened{
          account_uuid: account_uuid,
          initial_balance: initial_balance
        }
      ) do
    %__MODULE__{
      account
      | uuid: account_uuid,
        current_balance: initial_balance
    }
  end

  def apply(
        %__MODULE__{uuid: account_uuid} = account,
        %AccountClosed{
          account_uuid: account_uuid
        }
      ) do
    %__MODULE__{
      account
      | closed?: true
    }
  end

  def apply(
        %__MODULE__{uuid: account_uuid} = account,
        %DepositedIntoAccount{
          account_uuid: account_uuid,
          new_current_balance: new_current_balance
        }
      ) do
    %__MODULE__{
      account
      | current_balance: new_current_balance
    }
  end

  def apply(
        %__MODULE__{uuid: account_uuid} = account,
        %WithdrawnFromAccount{
          account_uuid: account_uuid,
          new_current_balance: new_current_balance
        }
      ) do
    %__MODULE__{
      account
      | current_balance: new_current_balance
    }
  end
end
