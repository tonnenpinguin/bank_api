defmodule BankAPI.Accounts.Projectors.AccountOpened do
  use Commanded.Projections.Ecto,
    name: "Accounts.Projectors.AccountOpened",
    application: BankAPI.CommandedApplication,
    repo: BankAPI.Repo

  alias BankAPI.Accounts.Events
  alias BankAPI.Accounts.Projections.Account

  project(%Events.AccountOpened{} = event, _metadata, fn multi ->
    Ecto.Multi.insert(multi, :account_opened, %Account{
      uuid: event.account_uuid,
      current_balance: event.initial_balance
    })
  end)
end
