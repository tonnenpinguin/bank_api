defmodule BankAPI.Accounts.Supervisor do
  use Supervisor

  alias BankAPI.Accounts.{Projectors, ProcessManagers}

  def start_link(args \\ nil) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_arg) do
    children = [
      Supervisor.child_spec(Projectors.AccountOpened, id: :account_opened),
      Supervisor.child_spec(Projectors.AccountClosed, id: :account_closed),
      Supervisor.child_spec(Projectors.DepositsAndWithdrawals, id: :deposits_and_withdrawals),
      Supervisor.child_spec(ProcessManagers.TransferMoney, id: :transfer_money)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
