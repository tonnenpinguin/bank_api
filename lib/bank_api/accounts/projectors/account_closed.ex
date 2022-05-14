defmodule BankAPI.Accounts.Projectors.AccountClosed do
  use Commanded.Projections.Ecto,
    name: "Accounts.Projectors.AccountClosed",
    application: BankAPI.App,
    repo: BankAPI.Repo,
    consistency: :strong

  alias BankAPI.Accounts
  alias BankAPI.Accounts.Events.AccountClosed
  alias BankAPI.Accounts.Projections.Account
  alias Ecto.{Changeset, Multi}

  project(%AccountClosed{account_uuid: account_uuid}, fn multi ->
    with {:ok, %Account{} = account} <- Accounts.get_account(account_uuid) do
      Multi.update(
        multi,
        :account,
        Changeset.change(account, status: :closed)
      )
    end
  end)
end
