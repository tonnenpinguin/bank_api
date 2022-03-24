defmodule BankAPI.Accounts.Supervisor do
  use Supervisor

  alias BankAPI.Accounts.Projectors

  def start_link(args \\ nil) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_arg) do
    children = [Supervisor.child_spec(Projectors.AccountOpened, id: :account_opened)]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
